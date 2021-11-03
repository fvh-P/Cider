//
//  LilyRepository.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/24.
//

import Moya
import Foundation

typealias LilyListResult = Result<[Lily], SparqlError>
typealias LilyDetailResult = Result<Lily, SparqlError>

protocol LilyRepository {
    func getLilyList(completion: @escaping (LilyListResult) -> Void)
    func getLilyDetail(resource: String, completion: @escaping (LilyDetailResult) -> Void)
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
                    guard let _ = try? response.filterSuccessfulStatusCodes() else {
                        let message = (try? response.mapString()) ?? "No message"
                        let detail = "\(response.statusCode), \(message)"
                        switch response.statusCode {
                        case 400:
                            return .failure(.badRequest)
                        case 404:
                            return .failure(.endpointNotFound)
                        case 502:
                            return .failure(.badGateway)
                        case 503:
                            return .failure(.serviceTemporarilyUnavailable)
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
                    return .success(Lily.convertForListView(from: dict_lilies, legions: legions))
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(lilyListResult)
        }
    }
    
    func getLilyDetail(resource: String, completion: @escaping (LilyDetailResult) -> Void) {
        
        let slug = URL(string: resource)!.lastPathComponent
        MoyaProvider<SparqlAPI>().request(.lilyDetail(slug: slug)) { result in
            let lilyDetailResult: LilyDetailResult = ({
                switch result {
                case .success(let response):
                    guard let _ = try? response.filterSuccessfulStatusCodes() else {
                        let message = (try? response.mapString()) ?? "No message"
                        let detail = "\(response.statusCode), \(message)"
                        switch response.statusCode {
                        case 400:
                            return .failure(.badRequest)
                        case 404:
                            return .failure(.endpointNotFound)
                        case 502:
                            return .failure(.badGateway)
                        case 503:
                            return .failure(.serviceTemporarilyUnavailable)
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
                    let dict_charms = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Charm"
                        })
                    })
                    let charms = Charm.convertForOutline(from: dict_charms)
                    let dict_relations = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            (triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Lily"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Teacher"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Character")
                                && URL(string: triple.subject.value)?.lastPathComponent != slug
                        })
                    })
                    let relations = Lily.convertForRelations(from: dict_relations)
                    
                    let dict_legions = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Legion"
                        })
                    })
                    let legions = Legion.convert(from: dict_legions)
                    
                    let dict_media = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Play"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Game"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#AnimeSeries"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Book"
                        })
                    })
                    let media = Media.convert(from: dict_media)
                    
                    let lily_triples = dict[resource]!

                    let bnodes = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.subject.type == "bnode"
                        })
                    })
                    return .success(Lily.convertForDetailView(from: slug, triples: lily_triples, bnodes: bnodes, charms: charms, legions: legions, relations: relations, media: media))
                    
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(lilyDetailResult)
        }
    }
}
