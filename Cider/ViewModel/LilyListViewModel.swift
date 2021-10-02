//
//  LilyListViewModel.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/25.
//

import SwiftUI

class LilyListViewModel: LilyRepositoryInjectable, ImageRecordRepositoryInjectable, ObservableObject {
    @Published var lilies: [Lily] = []
    @Published var imageRecords: [ImageRecord] = []
    @Published var state: LoadingState = .loading
    @Published var searchText: String = ""
    @Published var gardenSelection = "指定なし"
    @Published var showGardenPicker = false
    @Published var legionSelection = "指定なし"
    @Published var showLegionPicker = false
    @Published var skillSelection = "指定なし"
    @Published var showSkillPicker = false
    
    func loadLilyList() -> Void {
        if self.lilies.isEmpty {
            self.state = .loading
        }
        self.lilyRepository.getLilyList() { result in
            switch result {
            case .failure(let reason):
                if self.lilies.isEmpty {
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
                
            case .success(let lilies):
                self.state = .success
                self.lilies = lilies
            }
        }
    }
    
    func loadImageRecords() {
        if !self.imageRecords.isEmpty {
            return
        }
        self.imageRecordRepository.getImageList() { result in
            switch result {
            case .success(let records):
                self.imageRecords = records
            case .failure(let reason):
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
    
    func resetSelections() {
        self.searchText = ""
        self.gardenSelection = "指定なし"
        self.legionSelection = "指定なし"
        self.skillSelection = "指定なし"
    }
    
    var filteredLilies: [Lily] {
        var filtered = lilies
        if !self.searchText.isEmpty {
            filtered = filtered.filter({
                $0.name?.contains(self.searchText) == true
                    || $0.nameKana?.contains(self.searchText) == true
                    || $0.nameEn?.lowercased().contains(self.searchText.lowercased()) == true
            })
        }
        if self.gardenSelection != "指定なし" {
            filtered = filtered.filter({
                $0.garden == self.gardenSelection
            })
        }
        if self.legionSelection == "レギオン情報なし" {
            filtered = filtered.filter({
                $0.legion == nil
            })
        } else if self.legionSelection != "指定なし" {
            filtered = filtered.filter({
                $0.legion?.name == self.legionSelection
            })
        }
        if self.skillSelection != "指定なし" {
            filtered = filtered.filter({
                $0.rareSkill == self.skillSelection
                    || $0.subSkill.contains(self.skillSelection)
                    || $0.boostedSkill.contains(self.skillSelection)
            })
        }
        
        return filtered
    }
    var gardens: [String] {
        var arr = ["指定なし"]
        arr.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.garden
        }))).sorted())
        return arr
    }
    var legions: [String] {
        var arr = ["指定なし","レギオン情報なし"]
        arr.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.legion?.name
        }))).sorted())
        return arr
    }
    var skills: [[String]] {
        var rareskills = ["指定なし"]
        rareskills.append(contentsOf: Array(Set(lilies.compactMap({ l -> String? in
            return l.rareSkill
        }))).sorted())
        var subskills = ["指定なし"]
        subskills.append(contentsOf: Array(Set(lilies.flatMap({ l -> [String] in
            return l.subSkill
        }))).sorted())
        var boostedskills = ["指定なし"]
        boostedskills.append(contentsOf: Array(Set(lilies.flatMap({ l -> [String] in
            return l.boostedSkill
        }))).sorted())
        var arr = [[String]]()
        arr.append(rareskills)
        arr.append(subskills)
        arr.append(boostedskills)
        return arr
    }
}
