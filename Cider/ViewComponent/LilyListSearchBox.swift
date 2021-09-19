//
//  LilyListSearchBox.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

struct LilyListSearchBox: View {
    @Binding var searchText: String
    @Binding var gardenSelection: String
    @Binding var legionSelection: String
    @Binding var skillSelection: String
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var gardens: [String]
    var legions: [String]
    var skills: [[String]]
    @State var searchExpanded = false
    
    var selectionsText: String {
        if self.searchExpanded || self.gardenSelection == "指定なし" && self.legionSelection == "指定なし"  && self.skillSelection == "指定なし"  {
            return ""
        }
        var selections: [String] = []
        if self.gardenSelection != "指定なし" {
            selections.append(self.gardenSelection)
        }
        if self.legionSelection != "指定なし" {
            selections.append(self.legionSelection)
        }
        if self.skillSelection != "指定なし" {
            selections.append(self.skillSelection)
        }
        return ": [\(selections.joined(separator: ", "))]"
    }
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $searchExpanded,
            content: {
                HStack {
                    Text("名前: ")
                    TextField("", text: $searchText)
                        .placeholder(when: self.searchText.isEmpty) {
                            Text("名前の一部を入力")
                                .foregroundColor(Color(.systemGray3))
                        }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { GardenPicker(gardenSelection: $gardenSelection, gardens: gardens)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("ガーデン: ")
                        if self.gardenSelection == "指定なし" {
                            Text(self.gardenSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.gardenSelection)
                        }
                    }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { LegionPicker(legionSelection: $legionSelection, legions: legions)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("レギオン: ")
                        if self.legionSelection == "指定なし" {
                            Text(self.legionSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.legionSelection)
                        }
                    }
                }
                Button(action: {
                    self.partialSheetManager.showPartialSheet { SkillPicker(skillSelection: $skillSelection, skills: skills)
                        .frame(maxHeight: 400)
                    }
                }) {
                    HStack {
                        Text("スキル: ")
                        if self.skillSelection == "指定なし" {
                            Text(self.skillSelection)
                                .foregroundColor(Color(.systemGray3))
                        } else {
                            Text(self.skillSelection)
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
