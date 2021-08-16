//
//  LilyListView_Extension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import Foundation

extension LilyListView {
    var filteredLilies: [Lily] {
        var filtered = lilies
        if !self.searchText.isEmpty {
            filtered = filtered.filter({
                $0.name?.contains(self.searchText) == true
                    || $0.nameKana?.contains(self.searchText) == true
                    || $0.nameEn?.lowercased().contains(self.searchText.lowercased()) == true
            })
        }
        if self.gardenSelection != "指定なし" {
            filtered = filtered.filter({
                $0.garden == self.gardenSelection
            })
        }
        if self.legionSelection == "レギオン情報なし" {
            filtered = filtered.filter({
                $0.legion == nil
            })
        } else if self.legionSelection != "指定なし" {
            filtered = filtered.filter({
                $0.legion?.name == self.legionSelection
            })
        }
        if self.skillSelection != "指定なし" {
            filtered = filtered.filter({
                $0.rareSkill == self.skillSelection
                    || $0.subSkill.contains(self.skillSelection)
                    || $0.boostedSkill.contains(self.skillSelection)
            })
        }
        
        return filtered
    }
    var gardens: [String] {
        var arr = ["指定なし"]
        arr.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.garden
        }))).sorted())
        return arr
    }
    var legions: [String] {
        var arr = ["指定なし","レギオン情報なし"]
        arr.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.legion?.name
        }))).sorted())
        return arr
    }
    var skills: [[String]] {
        var rareskills = ["指定なし"]
        rareskills.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.rareSkill
        }))).sorted())
        var subskills = ["指定なし"]
        subskills.append(contentsOf: Array(Set(lilies.flatMap({ l -> [String] in
            return l.subSkill
        }))).sorted())
        var boostedskills = ["指定なし"]
        boostedskills.append(contentsOf: Array(Set(lilies.flatMap({ l -> [String] in
            return l.boostedSkill
        }))).sorted())
        var arr = [[String]]()
        arr.append(rareskills)
        arr.append(subskills)
        arr.append(boostedskills)
        return arr
    }

    func loadLilyList() {
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
                self.lilies = (Lily.convertForListView(from: dict_lilies, legions: legions).sorted {
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
    VALUES ?class { lily:Lily lily:Teacher lily:Character lily:Legion }
    VALUES ?predicate {
        schema:name lily:nameKana lily:givenNameKana foaf:age
        lily:rareSkill lily:subSkill lily:isBoosted lily:boostedSkill
        lily:garden lily:grade lily:legion lily:legionJobTitle lily:position
        schema:height schema:weight lily:bloodType lily:alternateName rdf:type
    }
    ?subject a ?class;
             ?predicate ?object.
}
"""
}
