//
//  LilyRepository.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/24.
//

import Moya

typealias LilyListResult = Result<[Lily], SparqlError>
typealias LilyDetailResult = Result<Lily, SparqlError>

enum SparqlError: Error {
    case badRequest(detail: String)
    case endpointNotFound(detail: String)
    case serviceTemporarilyUnavailable(detail: String)
    case badGateway(detail: String)
    case other(detail: String)
    
    var detail: String {
        switch self {
        case .badRequest(detail: let detail), .endpointNotFound(detail: let detail), .serviceTemporarilyUnavailable(detail: let detail), .badGateway(detail: let detail), .other(detail: let detail):
            return detail
        }
    }
}

protocol LilyRepository {
    func getLilyList(completion: @escaping (LilyListResult) -> Void)
}

protocol LilyRepositoryInjectable {
    var lilyRepository: LilyRepository { get }
}

extension LilyRepositoryInjectable {
    var lilyRepository: LilyRepository {
        return LilyRepositoryImpl.shared
    }
}

fileprivate class LilyRepositoryImpl: LilyRepository {
    private init() {}
    static let shared = LilyRepositoryImpl()
    
    func getLilyList(completion: @escaping (LilyListResult) -> Void) {
        MoyaProvider<SparqlAPI>().request(.lilyList) { result in
            let lilyListResult: LilyListResult = ({
                switch result {
                case .success(let response):
                    guard let response = try? response.filterSuccessfulStatusCodes() else {
                        let message = (try? response.mapString()) ?? "No message"
                        let detail = "\(response.statusCode), \(message)"
                        switch response.statusCode {
                        case 400:
                            return .failure(.badRequest(detail: detail))
                        case 404:
                            return .failure(.endpointNotFound(detail: detail))
                        case 502:
                            return .failure(.badGateway(detail: detail))
                        case 503:
                            return .failure(.serviceTemporarilyUnavailable(detail: detail))
                        default:
                            break
                        }
                        
                        return .failure(.other(detail: detail))
                    }
                    
                    guard let sparqlResponse = try? response.map(SparqlResponse.self) else {
                        return .failure(.other(detail: "SPARQL API response mapping error"))
                    }
                    let dict = Dictionary.init(grouping: (sparqlResponse.results.bindings), by: { (elem) -> String in
                        return elem.subject.value
                    })
                    let dict_legions = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Legion"
                        })
                    })
                    let legions = Legion.convert(from: dict_legions)
                    
                    let dict_lilies = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Lily"
                        })
                    })
                    return .success(Lily.convertForListView(from: dict_lilies, legions: legions).sorted {
                        if $0.nameKana == nil {
                            return false
                        }
                        else if $1.nameKana == nil {
                            return true
                        }
                        else {
                            return $0.nameKana! < $1.nameKana!
                        }
                    })
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(lilyListResult)
        }
    }
}
