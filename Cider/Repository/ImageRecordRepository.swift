//
//  ImageRecordRepository.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
//

import Moya
import Foundation

typealias ImageListResult = Result<[ImageRecord], ImageRecordError>

protocol ImageRecordRepository {
    func getImageList(completion: @escaping (ImageListResult) -> Void)
    func getImage(resource: String, completion: @escaping (ImageListResult) -> Void)
}

protocol ImageRecordRepositoryInjectable {
    var imageRecordRepository: ImageRecordRepository { get }
}

extension ImageRecordRepositoryInjectable {
    var imageRecordRepository: ImageRecordRepository {
        return ImageRecordRepositoryImpl.shared
    }
}

fileprivate class ImageRecordRepositoryImpl: ImageRecordRepository {
    private init() {}
    static let shared = ImageRecordRepositoryImpl()
    
    func getImageList(completion: @escaping (ImageListResult) -> Void) {
        MoyaProvider<ImageRecordAPI>().request(.imageList) { result in
            let imageListResult: ImageListResult = ({
                switch result {
                case .success(let response):
                    guard let _ = try? response.filterSuccessfulStatusCodes() else {
                        let message = (try? response.mapString()) ?? "No message"
                        let detail = "\(response.statusCode), \(message)"
                        switch response.statusCode {
                        case 403:
                            return .failure(.forbidden)
                        case 404:
                            return .failure(.endpointNotFound)
                        case 502:
                            return .failure(.badGateway)
                        case 503:
                            return .failure(.serviceTemporarilyUnavailable)
                        default:
                            break
                        }
                        
                        return .failure(.other(detail: detail))
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    guard let images = try? response.map([ImageRecord].self, atKeyPath: "Items", using: decoder) else {
                        return .failure(.other(detail: "Image API response mapping error"))
                    }
                    return .success(images)
                    
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(imageListResult)
        }
    }
    
    func getImage(resource: String, completion: @escaping (ImageListResult) -> Void) {
        guard let slug = URL(string: resource)?.lastPathComponent else {
            completion(.failure(.other(detail: "リソース名が正しくありません。")))
            return
        }
        let loggerConf = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let netLogger = NetworkLoggerPlugin(configuration: loggerConf)
        MoyaProvider<ImageRecordAPI>(plugins: [netLogger]).request(.image(slug: slug)) { result in
            let imageListResult: ImageListResult = ({
                switch result {
                case .success(let response):
                    guard let _ = try? response.filterSuccessfulStatusCodes() else {
                        let message = (try? response.mapString()) ?? "No message"
                        let detail = "\(response.statusCode), \(message)"
                        switch response.statusCode {
                        case 403:
                            return .failure(.forbidden)
                        case 404:
                            return .failure(.endpointNotFound)
                        case 502:
                            return .failure(.badGateway)
                        case 503:
                            return .failure(.serviceTemporarilyUnavailable)
                        default:
                            break
                        }
                        
                        return .failure(.other(detail: detail))
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    guard let images = try? response.map([ImageRecord].self, atKeyPath: "Items", using: decoder) else {
                        return .failure(.other(detail: "Image Record API response mapping error"))
                    }
                    return .success(images)
                    
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(imageListResult)
        }
    }
}
