//
//  Media.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/07/19.
//

import Foundation

enum Media: Identifiable, Codable {
    
    var id: UUID { UUID() }
    
    case play(Play)
    case game(Game)
    case animeSeries(AnimeSeries)
    case book(Book)
}

extension Media {
    private enum CodingKeys: String, CodingKey {
        case play
        case game
        case animeSeries
        case book
    }
    
    enum PostTypeCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(Play.self, forKey: .play) {
            self = .play(value)
            return
        }
        if let value = try? values.decode(Game.self, forKey: .game) {
            self = .game(value)
            return
        }
        if let value = try? values.decode(AnimeSeries.self, forKey: .animeSeries) {
            self = .animeSeries(value)
            return
        }
        if let value = try? values.decode(Book.self, forKey: .book) {
            self = .book(value)
            return
        }
        throw PostTypeCodingError.decoding("Decode Error!\n \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .play(let play):
            try container.encode(play, forKey: .play)
        case .game(let game):
            try container.encode(game, forKey: .game)
        case .animeSeries(let animeSeries):
            try container.encode(animeSeries, forKey: .animeSeries)
        case .book(let book):
            try container.encode(book, forKey: .book)
        }
    }
    
    private static let schema = "http://schema.org/"
    private static let lily = "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#"
    private static let rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    
    public static func convert(from dict: Dictionary<String, [Triple]>) -> [Media] {
        return dict.map({(key, triples) -> Media in
            let genre = TriplesHelper.findOne(triples: triples, predicate: "\(Self.lily)genre")?.object.value
            let name = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)name")?.object.value
            let alternateName = TriplesHelper.findOne(triples: triples, predicate: "\(Self.schema)alternateName")?.object.value
            let RDFType = TriplesHelper.findOne(triples: triples, predicate: "\(Self.rdf)type")?.object.value
            switch RDFType {
            case "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Play":
                return .play(Play(resource: key, genre: genre, name: name, alternateName: alternateName, RDFType: RDFType))
            case "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Game":
                return .game(Game(resource: key, genre: genre, name: name, alternateName: alternateName, RDFType: RDFType))
            case "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#AnimeSeries":
                return .animeSeries(AnimeSeries(resource: key, genre: genre, name: name, RDFType: RDFType))
            case "https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#Book":
                return .book(Book(resource: key, genre: genre, name: name, RDFType: RDFType))
            default:
                fatalError()
            }
        })
    }
    
    func getGenre() -> String? {
        switch self {
        case .play(let play):
            return play.genre
        case .game(let game):
            return game.genre
        case .animeSeries(let anime):
            return anime.genre
        case .book(let book):
            return book.genre
        }
    }
    
    func getName(getShortNameWhenLong shortName: Bool) -> String? {
        switch self {
        case .play(let play):
            return shortName && (play.name?.count ?? 0 > 30) ? play.alternateName : play.name
        case .game(let game):
            return shortName && (game.name?.count ?? 0 > 30) ? game.alternateName : game.name
        case .animeSeries(let anime):
            return anime.name
        case .book(let book):
            return book.name
        }
    }
}

class Play: Identifiable, Codable {
    var resource: String
    var genre: String?
    var name: String?
    var alternateName: String?
    var RDFType: String?
    
    init(resource: String = "", genre: String? = nil, name: String? = nil, alternateName: String? = nil, RDFType: String? = nil) {
        self.resource = resource
        self.genre = genre
        self.name = name
        self.alternateName = alternateName
        self.RDFType = RDFType
    }
}

class Game: Identifiable, Codable {
    var resource: String
    var genre: String?
    var name: String?
    var alternateName: String?
    var RDFType: String?
    
    init(resource: String = "", genre: String? = nil, name: String? = nil, alternateName: String? = nil, RDFType: String? = nil) {
        self.resource = resource
        self.genre = genre
        self.name = name
        self.alternateName = alternateName
        self.RDFType = RDFType
    }
}

class AnimeSeries: Identifiable, Codable {
    var resource: String
    var genre: String?
    var name: String?
    var RDFType: String?
    
    init(resource: String = "", genre: String? = nil, name: String? = nil, RDFType: String? = nil) {
        self.resource = resource
        self.genre = genre
        self.name = name
        self.RDFType = RDFType
    }
}

class Book: Identifiable, Codable {
    var resource: String
    var genre: String?
    var name: String?
    var RDFType: String?
    
    init(resource: String = "", genre: String? = nil, name: String? = nil, RDFType: String? = nil) {
        self.resource = resource
        self.genre = genre
        self.name = name
        self.RDFType = RDFType
    }
}

