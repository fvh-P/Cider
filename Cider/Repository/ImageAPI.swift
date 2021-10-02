//
//  ImageAPI.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

import Moya

enum ImageAPI {
    case image(url: URL)
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .image(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .image(_):
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [:]
        }
    }
}
