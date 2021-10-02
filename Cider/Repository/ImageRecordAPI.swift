//
//  ImageRecordAPI.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
//

import Moya

enum ImageRecordAPI {
    case imageList
    case image(slug: String)
}

extension ImageRecordAPI: TargetType {
    var baseURL: URL {
        ImageRecordConstant.baseURL
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
            return .post
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
        case .imageList:
        return .requestParameters(parameters: ["OperationType": "SCAN"], encoding: JSONEncoding.default)
        case .image(let slug):
            return .requestParameters(parameters: ["OperationType": "FILTER", "filter_key": "for", "filter_value": slug], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }
}
