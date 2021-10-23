//
//  Lily.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

class Lily: Identifiable, Codable {
    var resource: String
    var familyName: String?
    var familyNameKana: String?
    var familyNameEn: String?
    var additionalName: String?
    var additionalNameKana: String?
    var additionalNameEn: String?
    var givenName: String?
    var givenNameKana: String?
    var givenNameEn: String?
    var name: String?
    var nameKana: String?
    var nameEn: String?
    var anotherName: [String]
    var age: Int?
    var height: Double?
    var weight: Double?
    var birthDate: Date?
    var lifeStatus: String?
    var killedIn: String?
    var bloodType: String?
    var color: Color?
    var birthPlace: String?
    var favorite: [String]
    var notGood: [String]
    var hobbyTalent: [String]
    var skillerVal: Int?
    var rareSkill: String?
    var subSkill: [String]
    var isBoosted: Bool?
    var boostedSkill: [String]
    var charm: [LilyCharm]
    var garden: String?
    var gardenDepartment: String?
    var grade: Int?
    var gardenClass: String?
    var gardenJobTitle: [String]
    var rank: Int?
    var legion: Legion?
    var legionJobTitle: [String]
    var position: [String]
    var pastLegion: [Legion]
    var schutzengel: Lily?
    var pastSchutzengel: [Lily]
    var schild: Lily?
    var pastSchild: [Lily]
    var olderSchwester: Lily?
    var pastOlderSchwester: [Lily]
    var youngerSchwester: Lily?
    var pastYoungerSchwester: [Lily]
    var roomMate: Lily?
    var sibling: [Relationship]
    var relationship: [Relationship]
    var cast: [LilyCast]
    var RDFType: String?
    
    var id: String { resource }
    var gradeString: String? {
        guard let h = grade else {
            return nil
        }
        if h >= 10 {
            return "\(h - 9)年"
        }
        else if h >= 7 {
            return "\(h - 6)年"
        }
        else {
            return "\(h)年"
        }
    }
    var rareSkillLabelString: String? {
        switch self.rareSkill {
        case "ファンタズム":
            return "bolt.horizontal.circle"
        case "鷹の目":
            return "eye.circle"
        case "ルナティックトランサー":
            return "moon.stars"
        case "天の秤目":
            return "scope"
        case "ヘリオスフィア":
            return "shield.checkerboard"
        case "ブレイブ":
            return "flame"
        case "縮地":
            return "wind"
        case "レジスタ":
            return "atom"
        case "テスタメント":
            return "dot.arrowtriangles.up.right.down.left.circle"
        case "ゼノンパラドキサ":
            return "arrowshape.turn.up.left.2"
        case "円環の御手":
            return "hands.sparkles" //"flag.filled.and.flag.crossed"
        case "Z":
            return "timer"
        case "ユーバーザイン":
            return "aqi.medium"
        case "この世の理":
            return "move.3d"
        case "フェイズトランセンデンス":
            return "tornado"
        case "ラプラス":
            return "crown"
        case "カリスマ":
            return "crown"
        default:
            return nil
        }
    }
    
    public func getAllRelations() -> [Relationship] {
        var relations: [Relationship] = []
        if let schutzengel = self.schutzengel {
            relations.append(Relationship(value: schutzengel, relation: ["シュッツエンゲル"]))
        }
        if self.pastSchutzengel.count > 0 {
            relations.append(contentsOf: self.pastSchutzengel.map({ Relationship(value: $0, relation: ["過去のシュッツエンゲル"]) }))
        }
        if let schild = self.schild {
            relations.append(Relationship(value: schild, relation: ["シルト"]))
        }
        if self.pastSchild.count > 0 {
            relations.append(contentsOf: self.pastSchild.map({ Relationship(value: $0, relation: ["過去のシルト"]) }))
        }
        if let olderSchwester = self.olderSchwester {
            relations.append(Relationship(value: olderSchwester, relation: ["シュベスター(姉)"]))
        }
        if self.pastOlderSchwester.count > 0 {
            relations.append(contentsOf: self.pastOlderSchwester.map({ Relationship(value: $0, relation: ["過去のシュベスター(姉)"]) }))
        }
        if let youngerSchwester = self.youngerSchwester {
            relations.append(Relationship(value: youngerSchwester, relation: ["シュベスター(妹)"]))
        }
        if self.pastYoungerSchwester.count > 0 {
            relations.append(contentsOf: self.pastYoungerSchwester.map({ Relationship(value: $0, relation: ["過去のシュベスター(妹)"]) }))
        }
        if let roomMate = self.roomMate {
            if var r = relations.first(where: { $0.value.resource == roomMate.resource }) {
                r.relation.append("ルームメイト")
            } else {
                relations.append(Relationship(value: roomMate, relation: ["ルームメイト"]))
            }
        }
        
        self.sibling.forEach({ sib in
            if var r = relations.first(where: { $0.value.resource == sib.value.resource }) {
                r.relation.append(contentsOf: sib.relation)
            } else {
                relations.append(sib)
            }
        })
        
        self.relationship.forEach({ rel in
            if var r = relations.first(where: { $0.value.resource == rel.value.resource }) {
                r.relation.append(contentsOf: rel.relation)
            } else {
                relations.append(rel)
            }
        })
        
        return relations
    }
    
    init(resource: String = "", familyName: String? = nil, familyNameKana: String? = nil, familyNameEn: String? = nil, additionalName: String? = nil, additionalNameKana: String? = nil, additionalNameEn: String? = nil, givenName: String? = nil, givenNameKana: String? = nil, givenNameEn: String? = nil, name: String? = nil, nameKana: String? = nil, nameEn: String? = nil, anotherName: [String] = [], age: Int? = nil, height: Double? = nil, weight: Double? = nil, birthDate: Date? = nil, lifeStatus: String? = nil, killedIn: String? = nil, bloodType: String? = nil, color: Color? = nil, birthPlace: String? = nil, favorite: [String] = [], notGood: [String] = [], hobbyTalent: [String] = [], skillerVal: Int? = nil, rareSkill: String? = nil, subSkill: [String] = [], isBoosted: Bool? = nil, boostedSkill: [String] = [], charm: [LilyCharm] = [], garden: String? = nil, gardenDepartment: String? = nil, grade: Int? = nil, gardenClass: String? = nil, gardenJobTitle: [String] = [], rank: Int? = nil, legion: Legion? = nil, legionJobTitle: [String] = [], position: [String] = [], pastLegion: [Legion] = [], schutzengel: Lily? = nil, pastSchutzengel: [Lily] = [], schild: Lily? = nil, pastSchild: [Lily] = [], olderSchwester: Lily? = nil, pastOlderSchwester: [Lily] = [], youngerSchwester: Lily? = nil, pastYoungerSchwester: [Lily] = [], roomMate: Lily? = nil, sibling: [Relationship] = [], relationship: [Relationship] = [], cast: [LilyCast] = [], RDFType: String? = nil) {
        self.resource = resource
        self.familyName = familyName
        self.familyNameKana = familyNameKana
        self.familyNameEn = familyNameEn
        self.additionalName = additionalName
        self.additionalNameKana = additionalNameKana
        self.additionalNameEn = additionalNameEn
        self.givenName = givenName
        self.givenNameKana = givenNameKana
        self.givenNameEn = givenNameEn
        self.name = name
        self.nameKana = nameKana
        self.nameEn = nameEn
        self.anotherName = anotherName
        self.age = age
        self.height = height
        self.weight = weight
        self.birthDate = birthDate
        self.lifeStatus = lifeStatus
        self.killedIn = killedIn
        self.bloodType = bloodType
        self.color = color
        self.birthPlace = birthPlace
        self.favorite = favorite
        self.notGood = notGood
        self.hobbyTalent = hobbyTalent
        self.skillerVal = skillerVal
        self.rareSkill = rareSkill
        self.subSkill = subSkill
        self.isBoosted = isBoosted
        self.boostedSkill = boostedSkill
        self.charm = charm
        self.garden = garden
        self.gardenDepartment = gardenDepartment
        self.grade = grade
        self.gardenClass = gardenClass
        self.gardenJobTitle = gardenJobTitle
        self.rank = rank
        self.legion = legion
        self.legionJobTitle = legionJobTitle
        self.position = position
        self.pastLegion = pastLegion
        self.schutzengel = schutzengel
        self.pastSchutzengel = pastSchutzengel
        self.schild = schild
        self.pastSchild = pastSchild
        self.olderSchwester = olderSchwester
        self.pastOlderSchwester = pastOlderSchwester
        self.youngerSchwester = youngerSchwester
        self.pastYoungerSchwester = pastYoungerSchwester
        self.roomMate = roomMate
        self.sibling = sibling
        self.relationship = relationship
        self.cast = cast
        self.RDFType = RDFType
    }
}

struct LilyCharm: Identifiable, Codable {
    var id = UUID()
    var charm: Charm
    var usedIn: [String]
    var additinoalInformation: [String]
}

struct Relationship: Identifiable, Codable {
    var id = UUID()
    var value: Lily
    var relation: [String]
}

struct LilyCast :Identifiable, Codable {
    var id = UUID()
    var name: String?
    var performIn: [Media]
}

extension Lily {
    private static let schema = "http://schema.org/"
    private static let lily = "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#"
    private static let foaf = "http://xmlns.com/foaf/0.1/"
    private static let rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    
    public static func rareSkillLabelString(str: String?) -> String? {
        switch str {
        case "ファンタズム":
            return "bolt.horizontal.circle"
        case "鷹の目":
            return "eye.circle"
        case "ルナティックトランサー":
            return "moon.stars"
        case "天の秤目":
            return "scope"
        case "ヘリオスフィア":
            return "shield.checkerboard"
        case "ブレイブ":
            return "flame"
        case "縮地":
            return "wind"
        case "レジスタ":
            return "atom"
        case "テスタメント":
            return "dot.arrowtriangles.up.right.down.left.circle"
        case "ゼノンパラドキサ":
            return "arrowshape.turn.up.left.2"
        case "円環の御手":
            return "hands.sparkles" //"flag.filled.and.flag.crossed"
        case "Z":
            return "timer"
        case "ユーバーザイン":
            return "aqi.medium"
        case "この世の理":
            return "move.3d"
        case "フェイズトランセンデンス":
            return "tornado"
        case "ラプラス":
            return "crown"
        case "カリスマ":
            return "crown"
        default:
            return nil
        }
    }
    
    public static func subSkillLabelString(str: String?) -> String? {
        switch str {
        case "虹の軌跡":
            return "bolt.horizontal.circle"
        case "千里眼":
            return "eye.circle"
        case "狂乱の閾":
            return "moon.stars"
        case "魔眼":
            return "scope"
        case "聖域転換":
            return "shield.checkerboard"
        case "インビジブルワン":
            return "wind"
        case "軍神の加護":
            return "atom"
        case "約束の領域":
            return "dot.arrowtriangles.up.right.down.left.circle"
        case "ステルス":
            return "aqi.medium"
        case "Whole order":
            return "move.3d"
        case "Awakening":
            return "tornado"
        case "カリスマ":
            return "crown"
        default:
            return nil
        }
    }
    
    public static func boostedSkillLabelString(str: String?) -> String? {
        switch str {
        case "リジェネレーター":
            return "sparkles"
        case "アルケミートレース":
            return "drop.fill"
        case "エンハンスメント":
            return "capslock.fill"
        case "エーテルボディ":
            return "person.2.fill"
        case "ドレイン":
            return "leaf.fill"
        case "アストラルガーダー":
            return "shield.fill"
        case "連続強化補助":
            return "plus.diamond.fill"
        case "ノスフェラトゥ":
            return "infinity.circle.fill"
        case "マギリフレクター":
            return "camera.filters"
        default:
            return nil
        }
    }
    
    public static func convertForListView(from dict: Dictionary<String, [Triple]>, legions: [Legion]) -> [Lily] {
        return dict.map({(key, triples) -> Lily in
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let nameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)nameKana")?.object.value
            let nameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "en")?.object.value
            let givenNameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)givenNameKana")?.object.value
            let age_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.foaf)age")?.object.value
            let age: Int? = age_str?.parse()
            let birthDate: Date? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)birthDate")?.object.value.dateFromString(format: "--MM-dd")
            let rareSkill = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)rareSkill")?.object.value
            let subSkill = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)subSkill").map({t -> String in t.object.value})
            let isBoosted_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)isBoosted")?.object.value
            let isBoosted: Bool? = isBoosted_str?.parse()
            let boostedSkill = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)boostedSkill").map({t -> String in t.object.value})
            let garden = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)garden")?.object.value
            let grade_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)grade")?.object.value
            let grade: Int? = grade_str?.parse()
            let legion_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)legion")?.object.value
            let legion = legions.first(where: {legion -> Bool in
                legion.resource == legion_str
            })
            let legionJobTitle = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)legionJobTitle").map({t -> String in t.object.value})
            let position = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)position").map({t -> String in t.object.value})
            let height_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)height")?.object.value
            let height: Double? = height_str?.parse()
            let weight_str = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)weight")?.object.value
            let weight: Double? = weight_str?.parse()
            let bloodType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)bloodType")?.object.value
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
            
            return Lily(resource: key, givenNameKana: givenNameKana, name: name, nameKana: nameKana, nameEn: nameEn, age: age, height: height, weight: weight, birthDate: birthDate, bloodType: bloodType, rareSkill: rareSkill, subSkill: subSkill, isBoosted: isBoosted, boostedSkill: boostedSkill, garden: garden, grade: grade, legion: legion, legionJobTitle: legionJobTitle, position: position, RDFType: RDFType)
        })
    }
    
    public static func convertForDetailView(from key: String, triples: [Triple], bnodes: Dictionary<String, [Triple]>, charms: [Charm], legions: [Legion], relations: [Lily], media: [Media]) -> Lily {
        let familyName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)familyName")?.object.value
        let familyNameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)familyNameKana")?.object.value
        let familyNameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)familyName", langString: "en")?.object.value
        let additionalName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)additionalName")?.object.value
        let additionalNameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)additionalNameKana")?.object.value
        let additionalNameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)additionalName", langString: "en")?.object.value
        let givenName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)givenName")?.object.value
        let givenNameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)givenNameKana")?.object.value
        let givenNameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)givenName", langString: "en")?.object.value
        let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
        let nameKana = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)nameKana")?.object.value
        let nameEn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name", langString: "en")?.object.value
        let anotherName = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)anotherName").map { $0.object.value }
        let age: Int? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.foaf)age")?.object.value.parse()
        let height: Double? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)height")?.object.value.parse()
        let weight: Double? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)weight")?.object.value.parse()
        let birthDate: Date? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)birthDate")?.object.value.dateFromString(format: "--MM-dd")
        let lifeStatus = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)lifeStatus")?.object.value
        let killedIn = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)killedIn")?.object.value
        let bloodType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)bloodType")?.object.value
        let color = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)color")?.object.value.convertToColor()
        let birthPlace = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)birthPlace")?.object.value
        let favorite = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)favorite").map { $0.object.value }
        let notGood = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)notGood").map { $0.object.value }
        let hobbyTalent = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)hobby_talent").map { $0.object.value }
        let skillerVal: Int? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)skillerVal")?.object.value.parse()
        let rareSkill = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)rareSkill")?.object.value
        let subSkill = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)subSkill").map { $0.object.value }
        let isBoosted: Bool? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)isBoosted")?.object.value.parse()
        let boostedSkill = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)boostedSkill").map { $0.object.value }
        let charm = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)charm").map({t -> LilyCharm in
            let bnodeTriples = bnodes[t.object.value]!
            let resource = TriplesHelper.findOne(triples: bnodeTriples, predicate: "\(Self.lily)resource")?.object.value
            let usedIn = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)usedIn").map { $0.object.value }
            let additionalInformation = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)additionalInformation").map { $0.object.value }
            return LilyCharm(charm: charms.first(where: { $0.resource == resource })!, usedIn: usedIn, additinoalInformation: additionalInformation)
        })
        let garden = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)garden")?.object.value
        let gardenDepartment = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)gardenDepartment")?.object.value
        let rank: Int? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)rank")?.object.value.parse()
        let grade: Int? = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)grade")?.object.value.parse()
        let gardenClass = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)class")?.object.value
        let gardenJobTitle = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)gardenJobTitle").map { $0.object.value }
        let legion: Legion? = legions.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)legion")?.object.value })
        let legionJobTitle = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)legionJobTitle").map { $0.object.value }
        let position = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)position").map { $0.object.value }
        let pastLegion = legions.filter({ TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)pastLegion").map { $0.object.value }.contains($0.resource) })
        let schutzengel = relations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)schutzengel")?.object.value })
        let pastSchutzengel = relations.filter({TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)pastSchutzengel").map{ $0.object.value }.contains($0.resource) })
        let schild = relations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)schild")?.object.value })
        let pastSchild = relations.filter({TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)pastSchild").map { $0.object.value }.contains($0.resource) })
        let olderSchwester = relations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)olderSchwester")?.object.value })
        let pastOlderSchwester = relations.filter({TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)pastOlderSchwester").map { $0.object.value }.contains($0.resource) })
        let youngerSchwester = relations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)youngerSchwester")?.object.value })
        let pastYoungerSchwester = relations.filter({TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)pastYoungerSchwester").map { $0.object.value }.contains($0.resource) })
        let roomMate = relations.first(where: { $0.resource == TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)roomMate")?.object.value })
        let sibling = TriplesHelper.findMany(triples: triples, predicate: "\(Self.schema)sibling").map {t -> Relationship in
            let bnodeTriples = bnodes[t.object.value]!
            let resource = TriplesHelper.findOne(triples: bnodeTriples, predicate: "\(Self.lily)resource")?.object.value
            let relation = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)additionalInformation").map { $0.object.value }
            return Relationship(value: relations.first(where: { $0.resource == resource})!, relation: relation)
        }
        let relationship = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)relationship").map {t -> Relationship in
            let bnodeTriples = bnodes[t.object.value]!
            let resource = TriplesHelper.findOne(triples: bnodeTriples, predicate: "\(Self.lily)resource")?.object.value
            let relation = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)additionalInformation").map { $0.object.value }
            return Relationship(value: relations.first(where: { $0.resource == resource})!, relation: relation)
        }
        let cast = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)cast").map {t -> LilyCast in
            let bnodeTriples = bnodes[t.object.value]!
            let name = TriplesHelper.findOne(triples: bnodeTriples, predicate: "\(Self.schema)name")?.object.value
            let performIn = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)performIn").map { $0.object.value }
            return LilyCast(name: name, performIn: media.filter({m -> Bool in
                switch m {
                case .play(let p):
                    return performIn.contains(p.resource)
                case .game(let g):
                    return performIn.contains(g.resource)
                case .animeSeries(let a):
                    return performIn.contains(a.resource)
                case .book(let b):
                    return performIn.contains(b.resource)
                }
            }))
        }
        let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
        return Lily(resource: key, familyName: familyName, familyNameKana: familyNameKana, familyNameEn: familyNameEn, additionalName: additionalName, additionalNameKana: additionalNameKana, additionalNameEn: additionalNameEn, givenName: givenName, givenNameKana: givenNameKana, givenNameEn: givenNameEn, name: name, nameKana: nameKana, nameEn: nameEn, anotherName: anotherName, age: age, height: height, weight: weight, birthDate: birthDate, lifeStatus: lifeStatus, killedIn: killedIn, bloodType: bloodType, color: color, birthPlace: birthPlace, favorite: favorite, notGood: notGood, hobbyTalent: hobbyTalent, skillerVal: skillerVal, rareSkill: rareSkill, subSkill: subSkill, isBoosted: isBoosted, boostedSkill: boostedSkill, charm: charm, garden: garden, gardenDepartment: gardenDepartment, grade: grade, gardenClass: gardenClass, gardenJobTitle: gardenJobTitle, rank: rank, legion: legion, legionJobTitle: legionJobTitle, position: position, pastLegion: pastLegion, schutzengel: schutzengel, pastSchutzengel: pastSchutzengel, schild: schild, pastSchild: pastSchild, olderSchwester: olderSchwester, pastOlderSchwester: pastOlderSchwester, youngerSchwester: youngerSchwester, pastYoungerSchwester: pastYoungerSchwester, roomMate: roomMate, sibling: sibling, relationship: relationship, cast: cast, RDFType: RDFType)
    }
    
    public static func convertForRelations(from dict: Dictionary<String, [Triple]>) -> [Lily] {
        return dict.map({ (key, triples) -> Lily in
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
            return Lily(resource: key, name: name, RDFType: RDFType)
        })
    }
    
    public static func convertForCharmUser(from dict: Dictionary<String, [Triple]>, bnodes: Dictionary<String, [Triple]>) -> [Lily] {
        return dict.map({ (key, triples) -> Lily in
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let charm = TriplesHelper.findMany(triples: triples, predicate: "\(Self.lily)charm").compactMap({t -> LilyCharm? in
                guard let bnodeTriples = bnodes[t.object.value] else { return nil }
                let resource = TriplesHelper.findOne(triples: bnodeTriples, predicate: "\(Self.lily)resource")?.object.value
                let usedIn = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)usedIn").map { $0.object.value }
                let additionalInformation = TriplesHelper.findMany(triples: bnodeTriples, predicate: "\(Self.lily)additionalInformation").map { $0.object.value }
                return LilyCharm(charm: Charm(resource: resource ?? ""), usedIn: usedIn, additinoalInformation: additionalInformation)
            })
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
            return Lily(resource: key, name: name, charm: charm, RDFType: RDFType)
        })
    }
    
}
