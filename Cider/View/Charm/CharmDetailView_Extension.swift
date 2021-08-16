//
//  CharmDetailView_Extension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI
import Foundation

extension CharmDetailView {
    func loadCharmDetail(resource: String) {
        guard let url = URL(string: "https://lily.fvhp.net/sparql/query") else { fatalError() }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: nil != url.baseURL)
        let resourceName = URL(string: resource)?.lastPathComponent
        let queryString = Self.queryTemplate.replacingOccurrences(of: "$slug", with: resourceName!)
        components?.queryItems = [URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "query", value: queryString)]
        guard let reqUrl = components?.url else {
            fatalError("URL build error!")
        }
        
        let req = URLRequest(url: reqUrl)
        URLSession.shared.dataTask(with: req) { data, res, error in
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                fatalError()
            }
            guard let data = data, let res = res as? HTTPURLResponse else {
                print("No data or No response")
                fatalError()
            }
            
            if res.statusCode == 200 {
                let dict = DictionaryHelper.initDict(data: data)
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
                            && URL(string: triple.subject.value)?.lastPathComponent != resourceName
                    })
                })
                let lilies = Lily.convertForRelations(from: dict_lilies)
                let dict_corporations = dict.filter({(key, triples) -> Bool in
                    triples.contains(where: {triple -> Bool in
                        triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Corporation"
                    })
                })
                let corporations = Corporation.convert(from: dict_corporations)
                let charm_triples = dict[resource]!
                
                self.charm = Charm.convertForDetailView(from: resource, triples: charm_triples, charms: charms, lilies: lilies, corporations: corporations)
            }
            else {
                print("エラー: \(res.statusCode)")
                fatalError()
            }
        }.resume()
    }
    
    static let queryTemplate =
"""
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX lilyrdf: <https://lily.fvhp.net/rdf/RDFs/detail/>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?subject ?predicate ?object
WHERE{
  {
    VALUES ?subject { lilyrdf:$slug }
    ?subject ?predicate ?object.
  }
  UNION
  {
    VALUES ?rp { lily:user schema:manufacturer lily:isVariantOf lily:hasVariant }
    VALUES ?predicate { schema:name lily:charm rdf:type }
    lilyrdf:$slug ?rp ?subject.
    ?subject ?predicate ?object.
  }
  UNION
  {
    VALUES ?predicate { lily:resource lily:usedIn lily:additionalInformation }
    lilyrdf:$slug lily:user/lily:charm ?subject.
    ?subject lily:resource lilyrdf:$slug;
             ?predicate ?object.
  }
}
"""
}
