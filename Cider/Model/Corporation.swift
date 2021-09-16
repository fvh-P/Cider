//
//  Corporation.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import Foundation

struct Corporation: Identifiable, Codable {
    var resource: String
    var name: String?
    var nameEn: String?
    var RDFType: String?
    
    var id: String { resource }
}

extension Corporation {
    private static let schema = "http://schema.org/"
    private static let rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"

    public static func convert(from dict: Dictionary<String, [Triple]>) -> [Corporation] {
        return dict.map({(key, triples) -> Corporation in
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let nameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)nameEn")?.object.value
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value

            return Corporation(resource: key, name: name, nameEn: nameEn, RDFType: RDFType)
        })
    }
}
