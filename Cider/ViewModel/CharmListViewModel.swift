//
//  CharmListViewModel.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
//

import SwiftUI

class CharmListViewModel: CharmRepositoryInjectable, ObservableObject {
    @Published var charms: [Charm] = []
    @Published var state: LoadingState = .loading
    @Published var searchText: String = ""
    
    func loadCharmList() -> Void {
        if self.charms.isEmpty {
            self.state = .loading
        }
        self.charmRepository.getCharmList() { result in
            switch result {
            case .failure(let reason):
                if self.charms.isEmpty {
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
                
            case .success(let charms):
                self.state = .success
                self.charms = charms
            }
        }
    }
    
    func resetSelections() {
        self.searchText = ""
    }
    
    var filteredCharms: [Charm] {
        var filtered = charms
        if !self.searchText.isEmpty {
            filtered = filtered.filter({
                $0.name?.contains(self.searchText) == true
                    || $0.name?.contains(self.searchText.applyingTransform(.hiraganaToKatakana, reverse: false)!) == true
                    || $0.nameEn?.lowercased().contains(self.searchText.lowercased()) == true
            })
        }
        return filtered
    }
}
