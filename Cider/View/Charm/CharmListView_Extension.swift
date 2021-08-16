//
//  CharmListView_Extension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import Foundation

extension CharmListView {
    var filteredCharms: [Charm] {
        var filtered = charms
        if !self.searchText.isEmpty {
            filtered = filtered.filter({
                $0.name?.contains(self.searchText) == true
                    || $0.name?.contains(self.searchText.applyingTransform(.hiraganaToKatakana, reverse: false)!) == true
                    || $0.nameEn?.lowercased().contains(self.searchText.lowercased()) == true
            })
        }
        
        return filtered
    }

    func loadCharmList() {
        guard let url = URL(string: "https://lily.fvhp.net/sparql/query") else { fatalError() }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: nil != url.baseURL)
        components?.queryItems = [URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "query", value: Self.queryString)]
        guard let reqUrl = components?.url else {
            fatalError("URL build error!")
        }
        let req = URLRequest(url: reqUrl)
        URLSession.shared.dataTask(with: req) { data, res, error in
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }
            guard let data = data, let res = res as? HTTPURLResponse else {
                print("No data or No response")
                return
            }
            
            if res.statusCode == 200 {
                var result: SparqlResult?
                do {
                    result = try JSONDecoder().decode(SparqlResult.self, from: data)
                } catch {
                    print("JSON parse error")
                }
                let dict = Dictionary.init(grouping: (result?.results.bindings)!, by: { (elem) -> String in
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
                self.charms = Charm.convertForListView(from: dict_charms, corporations: corporations).sorted {
                    if $0.nameEn == nil {
                        return false
                    }
                    else if $1.nameEn == nil {
                        return true
                    }
                    else {
                        return $0.nameEn! < $1.nameEn!
                    }
                }
            }
            else {
                print("エラー: \(res.statusCode)")
            }
        }.resume()
    }
    
    static let queryString =
"""
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?subject ?predicate ?object
WHERE {
    VALUES ?class { lily:Charm lily:Corporation }
    VALUES ?predicate {
        schema:productID lily:seriesName schema:name lily:generation lily:requiredSkillerVal schema:manufacturer rdf:type
    }
    ?subject a ?class;
             ?predicate ?object.
}
"""
}

