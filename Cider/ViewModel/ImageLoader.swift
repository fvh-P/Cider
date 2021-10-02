//
//  ImageLoader.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

import UIKit
import Combine

class ImageLoader: ImageRepositoryInjectable, ObservableObject {
    @Published var image: UIImage?
    @Published var state: LoadingState = .loading
    
    private let url: URL
    private var cache: ImageCache?
    
    private(set) var isLoading = false
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        
        self.image = cache?[url as AnyObject]
    }
    
    private func fetchImage(url: URL) -> Void {
        self.imageRepository.getImage(url: url) { result in
            switch result {
            case .success(let image):
                self.state = .success
                self.image = image
                self.addCache(self.image)
            case .failure(let reason):
                self.state = .failure(msg: "読み込み失敗")
                switch reason {
                case .forbidden:
                    print("loadImageRecords: 403 Forbidden")
                case .endpointNotFound:
                    print("loadImageRecords: 404 Not Found")
                case .badGateway:
                    print("loadImageRecords: 502 Bad Gateway")
                case .serviceTemporarilyUnavailable:
                    print("loadImageRecords: 503 Service Temporarily Unavailable")
                case .other(let msg):
                    print(msg)
                }
            }
        }
    }
    
    private func addCache(_ image: UIImage?) {
        image.map { cache?[url as AnyObject] = $0 }
    }
    
    func load() {
        print(url)
        guard !isLoading else { return }
        
        if cache?[url as AnyObject] != nil { return }
        
        self.fetchImage(url: url)
    }
}
