//
//  ImageRecord.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
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
        self.authorInfo.components(separatedBy: .newlines)
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
