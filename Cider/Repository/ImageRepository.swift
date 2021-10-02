//
//  ImageRepository.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

import Moya
import SwiftUI
import Foundation

typealias ImageResult = Result<UIImage, ImageError>

protocol ImageRepository {
    func getImage(url: URL, completion: @escaping (ImageResult) -> Void)
}

protocol ImageRepositoryInjectable {
    var imageRepository: ImageRepository { get }
}

extension ImageRepositoryInjectable {
    var imageRepository: ImageRepository {
        return ImageRepositoryImpl.shared
    }
}

fileprivate class ImageRepositoryImpl: ImageRepository {
    private init() {}
    static let shared = ImageRepositoryImpl()
    
    func getImage(url: URL, completion: @escaping (ImageResult) -> Void) {
        let loggerConf = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let netLogger = NetworkLoggerPlugin(configuration: loggerConf)
        MoyaProvider<ImageAPI>(plugins: [netLogger]).request(.image(url: url)) { result in
            let imageResult: ImageResult = ({
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
                    
                    guard let image = UIImage(data: response.data) else {
                        return .failure(.other(detail: "Image API response convert error"))
                    }
                    return .success(image)
                    
                case .failure(let error):
                    return .failure(.other(detail: error.localizedDescription))
                }
            })()
            
            completion(imageResult)
        }
    }
}
