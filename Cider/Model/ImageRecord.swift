//
//  ImageRecord.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/09/30.
//

import Foundation

struct ImageRecord: Identifiable, Codable {
    var id: UUID
    var resource: String
    var imageUrl: URL
    var type: String
    var author: String
    var authorInfo: String
    var createdAt: Date
    var updatedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case resource = "for"
        case imageUrl = "image_url"
        case type
        case author
        case authorInfo = "author_info"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var lineSeparatedAuthorInfo: [String] {
        self.authorInfo.split(whereSeparator: \.isNewline).map({ String($0) })
    }
    
    var authorInfoDictionary: [String : String] {
        var dict: [String : String] = [:]
        self.lineSeparatedAuthorInfo.forEach({ str in
            let separated = str.components(separatedBy: ",")
            dict[separated[0]] = separated[1]
        })
        return dict
    }
}
