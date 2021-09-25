//
//  SparqlAPI.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/24.
//

import Moya

enum SparqlAPI {
    case lilyList
    case lilyDetail(slug: String)
    case charmList
    case charmDetail(slug: String)
}

extension SparqlAPI: TargetType {
    var baseURL: URL {
        SparqlConstant.baseURL
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
        case .lilyList:
            return .requestParameters(parameters: ["format": "json", "query": SparqlConstant.lilyListQuery], encoding: URLEncoding.queryString)
        case .lilyDetail(let slug):
            return .requestParameters(parameters: ["format": "json", "query": SparqlConstant.lilyDetailQueryTemplate.replacingOccurrences(of: "$slug", with: slug)], encoding: URLEncoding.queryString)
        case .charmList:
            return .requestParameters(parameters: ["format": "json", "query": SparqlConstant.charmListQuery], encoding: URLEncoding.queryString)
        case .charmDetail(let slug):
            return .requestParameters(parameters: ["format": "json", "query": SparqlConstant.charmDetailQueryTemplate.replacingOccurrences(of: "$slug", with: slug)], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [:]
        }
    }
}
