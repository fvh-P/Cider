//
//  LilyListSearchBox.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

struct LilyListSearchBox: View {
    @ObservedObject var lilyListVM: LilyListViewModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State var searchExpanded = false
    
    var selectionsText: String {
        if self.searchExpanded || self.lilyListVM.gardenSelection == "指定なし" && self.lilyListVM.legionSelection == "指定なし"  && self.lilyListVM.skillSelection == "指定なし"  {
            return ""
        }
        var selections: [String] = []
        if self.lilyListVM.gardenSelection != "指定なし" {
            selections.append(self.lilyListVM.gardenSelection)
        }
        if self.lilyListVM.legionSelection != "指定なし" {
            selections.append(self.lilyListVM.legionSelection)
        }
        if self.lilyListVM.skillSelection != "指定なし" {
            selections.append(self.lilyListVM.skillSelection)
        }
        return ": [\(selections.joined(separator: ", "))]"
    }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $searchExpanded,
            content: {
                HStack {
                    Text("名前: ")
                    TextField("", text: self.$lilyListVM.searchText)
                        .placeholder(when: self.lilyListVM.searchText.isEmpty) {
                            Text("名前の一部を入力")
                                .foregroundColor(Color(.systemGray3))
                        }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { GardenPicker(gardenSelection: self.$lilyListVM.gardenSelection, gardens: self.lilyListVM.gardens)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("ガーデン: ")
                        if self.lilyListVM.gardenSelection == "指定なし" {
                            Text(self.lilyListVM.gardenSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.lilyListVM.gardenSelection)
                        }
                    }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { LegionPicker(legionSelection: self.$lilyListVM.legionSelection, legions: self.lilyListVM.legions)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("レギオン: ")
                        if self.lilyListVM.legionSelection == "指定なし" {
                            Text(self.lilyListVM.legionSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.lilyListVM.legionSelection)
                        }
                    }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { SkillPicker(skillSelection: self.$lilyListVM.skillSelection, skills: self.lilyListVM.skills)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("スキル: ")
                        if self.lilyListVM.skillSelection == "指定なし" {
                            Text(self.lilyListVM.skillSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.lilyListVM.skillSelection)
                        }
                    }
                }
            },
            label: {
                Text("絞り込み\(self.selectionsText)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            self.searchExpanded.toggle()
                        }
                    }
            })
    }
}
