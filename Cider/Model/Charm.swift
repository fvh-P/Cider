
//
//  Charm.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/17.
//

import Foundation

class Charm: Identifiable {
    var resource: String
    var productID: String?
    var seriesName: String?
    var seriesNameEn: String?
    var name: String?
    var nameEn: String?
    var generation: Decimal?
    var requiredSkillerVal: Int?
    var manufacturer: Corporation?
    var user: [Lily]
    var isVariantOf: Charm?
    var hasVariant: [Charm]
    var additionalInformation: [String]
    var RDFType: String?
    
    var id: String { resource }
    init(resource: String = "", productID: String? = nil, seriesName: String? = nil, seriesNameEn: String? = nil, name: String? = nil, nameEn: String? = nil, generation: Decimal? = nil, requiredSkillerVal: Int? = nil, manufacturer: Corporation? = nil, user: [Lily] = [], isVariantOf: Charm? = nil, hasVariant: [Charm] = [], additionalInformation: [String] = [], RDFType: String? = nil) {
        self.resource = resource
        self.productID = productID
        self.seriesName = seriesName
        self.seriesNameEn = seriesNameEn
        self.name = name
        self.nameEn = nameEn
        self.generation = generation
        self.requiredSkillerVal = requiredSkillerVal
        self.manufacturer = manufacturer
        self.user = user
        self.isVariantOf = isVariantOf
        self.hasVariant = hasVariant
        self.additionalInformation = additionalInformation
        self.RDFType = RDFType
    }
}

extension Charm {
    private static let schema = "http://schema.org/"
    private static let lily = "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#"
    private static let rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    
    public static func convertForOutline(from dict: Dictionary<String, [Triple]>) -> [Charm] {
        return dict.map({(key, triples) -> Charm in
            let productID = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)productID")?.object.value
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "ja")?.object.value
            return Charm(resource: key, productID: productID, name: name)
        })
    }
    public static func convertForListView(from dict: Dictionary<String, [Triple]>, corporations: [Corporation]) -> [Charm] {
        return dict.map({(key, triples) -> Charm in
            let productID = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)productID")?.object.value
            let seriesName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)seriesName", langString: "ja")?.object.value
            let seriesNameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)seriesName", langString: "en")?.object.value
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "ja")?.object.value
            let nameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "en")?.object.value
            let generation_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)generation")?.object.value
            let generation: Decimal? = generation_str?.parse()
            let requiredSkillerVal_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)requiredSkillerVal")?.object.value
            let requiredSkillerVal: Int? = requiredSkillerVal_str?.parse()
            let manufacturer = corporations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)manufacturer")?.object.value })
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
            return Charm(resource: key, productID: productID, seriesName: seriesName, seriesNameEn: seriesNameEn, name: name, nameEn: nameEn, generation: generation, requiredSkillerVal: requiredSkillerVal, manufacturer: manufacturer, RDFType: RDFType)
        })
    }
    public static func convertForDetailView(from key: String, triples: [Triple], charms: [Charm], lilies: [Lily], corporations: [Corporation]) -> Charm {
        let productID = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)productID")?.object.value
        let seriesName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)seriesName", langString: "ja")?.object.value
        let seriesNameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)seriesName", langString: "en")?.object.value
        let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "ja")?.object.value
        let nameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "en")?.object.value
        let generation_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)generation")?.object.value
        let generation: Decimal? = generation_str?.parse()
        let requiredSkillerVal_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)requiredSkillerVal")?.object.value
        let requiredSkillerVal: Int? = requiredSkillerVal_str?.parse()
        let manufacturer = corporations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)manufacturer")?.object.value })
        let user = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)user").compactMap({ t -> Lily? in
            return lilies.first(where: { lily -> Bool in
                return t.object.value == lily.resource
            })
        })
        let isVariantOf = charms.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)isVariantOf")?.object.value })
        let hasVariant = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)hasVariant").compactMap({ t -> Charm? in
            return charms.first(where: { charm -> Bool in
                return t.object.value == charm.resource
            })
        })
        let additionalInformation = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)additionalInformation").map({ $0.object.value })
        let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
        return Charm(resource: key, productID: productID, seriesName: seriesName, seriesNameEn: seriesNameEn, name: name, nameEn: nameEn, generation: generation, requiredSkillerVal: requiredSkillerVal, manufacturer: manufacturer, user: user, isVariantOf: isVariantOf, hasVariant: hasVariant, additionalInformation: additionalInformation, RDFType: RDFType)
    }
}
