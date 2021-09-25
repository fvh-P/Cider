//
//  LilyDetailViewModel.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/26.
//

import SwiftUI

class LilyDetailViewModel: LilyRepositoryInjectable, ObservableObject {
    @Published var lily: Lily? = nil
    @Published var state: LoadingState = .loading
    
    func loadLilyDetail(resource: String) -> Void {
        if self.lily == nil {
            self.state = .loading
        }
        self.lilyRepository.getLilyDetail(resource: resource) { result in
            switch result {
            case .failure(let reason):
                if self.lily == nil {
                    switch reason {
                    case .endpointNotFound:
                        self.state = .failure(msg: "404: SPARQL APIにアクセスできません。開発者までお問い合わせください。")
                    case .badRequest:
                        self.state = .failure(msg: "400: SPARQLのクエリが不正です。開発者までお問い合わせください。")
                    case .badGateway:
                        self.state = .failure(msg: "502: SPARQL APIが正しく応答しません。メンテナンス中または障害が発生しています。数分待って再度お試しください。")
                    case .serviceTemporarilyUnavailable:
                        self.state = .failure(msg: "503: SPARQL APIが正しく応答しません。メンテナンス中または障害が発生しています。数分待って再度お試しください。")
                    case .other(let msg):
                        self.state = .failure(msg: msg)
                    }
                    
                } else {
                    self.state = .success
                }
                
            case .success(let lily):
                self.state = .success
                self.lily = lily
            }
        }
    }
}
