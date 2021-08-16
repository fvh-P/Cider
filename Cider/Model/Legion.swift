//
//  Legion.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

struct Legion {
    var resource: String
    var name: String?
    var alternateName: String?
    var RDFType: String?
    
    var id: String { resource }
}

extension Legion {
    private static let schema = "http://schema.org/"
    private static let rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"

    public static func convert(from dict: Dictionary<String, [Triple]>) -> [Legion] {
        return dict.map({(key, triples) -> Legion in
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let alternateName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)alternateName")?.object.value
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value

            return Legion(resource: key, name: name, alternateName: alternateName, RDFType: RDFType)
        })
    }
}
