//
//  SparqlResult.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

struct SparqlResult: Codable {
    var head: Head
    var results: Result
}

struct Head: Codable {
    var vars: [String]
}

struct Result: Codable {
    var bindings: [Triple]
}

struct Triple: Codable {
    var subject: Subject
    var predicate: Predicate
    var object: Object
}

struct Subject: Codable {
    var type: String
    var value: String
}

struct Predicate: Codable {
    var type: String
    var value: String
}

struct Object: Codable {
    var type: String
    var datatype: String?
    var lang: String?
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case datatype
        case lang = "xml:lang"
        case value
    }
}
