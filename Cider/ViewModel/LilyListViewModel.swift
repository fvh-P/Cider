//
//  LilyListViewModel.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/25.
//

import SwiftUI

class LilyListViewModel: LilyRepositoryInjectable, ObservableObject {
    @Published var lilies: [Lily] = []
    @Published var state: LoadingState = .loading
    @Published var searchText: String = ""
    @Published var gardenSelection = "指定なし"
    @Published var showGardenPicker = false
    @Published var legionSelection = "指定なし"
    @Published var showLegionPicker = false
    @Published var skillSelection = "指定なし"
    @Published var showSkillPicker = false
    
    func loadLilyList() -> Void {
        self.state = .loading
        self.lilyRepository.getLilyList() { result in
            switch result {
            case .failure(.endpointNotFound(let msg)),
                .failure(.badRequest(let msg)),
                .failure(.badGateway(let msg)),
                .failure(.serviceTemporarilyUnavailable(let msg)),
                .failure(.other(let msg)):
                if self.lilies.isEmpty {
                    self.state = .failure(msg: msg)
                } else {
                    self.state = .success
                }
            case .success(let lilies):
                self.state = .success
                self.lilies = lilies
            }
        }
    }
    
    var filteredLilies: [Lily] {
        print("aaa")
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
