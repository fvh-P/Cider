//
//  CharmRepository.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
//

import Moya
import Foundation

typealias CharmListResult = Result<[Charm], SparqlError>
typealias CharmDetailResult = Result<Charm, SparqlError>

protocol CharmRepository {
    func getCharmList(completion: @escaping (CharmListResult) -> Void)
    func getCharmDetail(resource: String, completion: @escaping (CharmDetailResult) -> Void)
}

protocol CharmRepositoryInjectable {
    var charmRepository: CharmRepository { get }
}

extension CharmRepositoryInjectable {
    var charmRepository: CharmRepository {
        return CharmRepositoryImpl.shared
    }
}

fileprivate class CharmRepositoryImpl: CharmRepository {
    private init() {}
    static let shared = CharmRepositoryImpl()
    
    func getCharmList(completion: @escaping (CharmListResult) -> Void) {
        MoyaProvider<SparqlAPI>().request(.charmList) { result in
            let charmListResult: CharmListResult = ({
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
                    let dict_corporations = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Corporation"
                        })
                    })
                    let corporations = Corporation.convert(from: dict_corporations)
                    
                    let dict_charms = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Charm"
                        })
                    })
                    return .success(Charm.convertForListView(from: dict_charms, corporations: corporations).sorted {
                        if $0.nameEn == nil {
                            return false
                        }
                        else if $1.nameEn == nil {
                            return true
                        }
                        else {
                            return $0.nameEn! < $1.nameEn!
                        }
                    })
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(charmListResult)
        }
    }
    
    func getCharmDetail(resource: String, completion: @escaping (CharmDetailResult) -> Void) {
        
        let slug = URL(string: resource)!.lastPathComponent
        MoyaProvider<SparqlAPI>().request(.charmDetail(slug: slug)) { result in
            let charmDetailResult: CharmDetailResult = ({
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
                    let dict_lilies = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            (triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Lily"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Teacher"
                                || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Character")
                                && URL(string: triple.subject.value)?.lastPathComponent != slug
                        })
                    })
                    
                    let bnodes = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.subject.type == "bnode"
                        })
                    })
                    let lilies = Lily.convertForCharmUser(from: dict_lilies, bnodes: bnodes)
                    let dict_corporations = dict.filter({(key, triples) -> Bool in
                        triples.contains(where: {triple -> Bool in
                            triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Corporation"
                        })
                    })
                    let corporations = Corporation.convert(from: dict_corporations)
                    let charm_triples = dict[resource]!
                    
                    return .success(Charm.convertForDetailView(from: resource, triples: charm_triples, charms: charms, lilies: lilies, corporations: corporations))
                    
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(charmDetailResult)
        }
    }
}

