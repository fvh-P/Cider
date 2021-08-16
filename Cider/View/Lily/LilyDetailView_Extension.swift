
import SwiftUI
import Foundation

extension LilyDetailView {
    func charmText(lilyCharm: LilyCharm) -> String {
        var charmTexts = ""
        if let pid = lilyCharm.charm.productID {
            charmTexts += "\(pid) "
        }
        if let name = lilyCharm.charm.name {
            charmTexts += "\(name) "
        }
        if lilyCharm.additinoalInformation.count > 0 {
            let infos = lilyCharm.additinoalInformation.joined(separator: ", ")
            charmTexts += "(\(infos))"
        }
        return charmTexts.trimmingCharacters(in: .whitespaces)
    }
    func loadLilyDetail(resource: String) {
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
                let dict_relations = dict.filter({(key, triples) -> Bool in
                    triples.contains(where: {triple -> Bool in
                        (triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Lily"
                            || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Teacher"
                            || triple.object.value == "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Character")
                            && URL(string: triple.subject.value)?.lastPathComponent != resourceName
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
                self.lily = Lily.convertForDetailView(from: resource, triples: lily_triples, bnodes: bnodes, charms: charms, legions: legions, relations: relations, media: media)
            }
            else {
                print("エラー: \(res.statusCode)")
                fatalError()
            }
        }.resume()
    }
    
    static let queryTemplate =
"""
PREFIX lilyrdf: <https://lily.fvhp.net/rdf/RDFs/detail/>
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX schema: <http://schema.org/>
SELECT ?subject ?predicate ?object
WHERE {
    {
        VALUES ?subject { lilyrdf:$slug }
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name schema:alternateName lily:resource lily:usedIn lily:performIn lily:additionalInformation rdf:type }
        lilyrdf:$slug ?rp ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:productID schema:name rdf:type }
        lilyrdf:$slug lily:charm/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name rdf:type }
        lilyrdf:$slug lily:relationship/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name rdf:type }
        lilyrdf:$slug schema:sibling/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { lily:genre schema:name schema:alternateName rdf:type }
        lilyrdf:$slug lily:cast/lily:performIn ?subject.
        ?subject ?predicate ?object.
    }
}
"""
}
