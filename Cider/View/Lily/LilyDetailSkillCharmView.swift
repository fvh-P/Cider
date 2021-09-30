//
//  LilyDetailSkillCharmView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/26.
//

import SwiftUI

struct LilyDetailSkillCharmView: View {
    let lily: Lily
    @State var charmExpanded: Bool = false
    var body: some View {
        if let rareSkill = lily.rareSkill {
            NavigationLink(destination: LilyListView(skillSelection: rareSkill)) {
                HStack {
                    Text("レアスキル")
                    Spacer()
                    Text(rareSkill)
                    if let iconString = lily.rareSkillLabelString {
                        Image(systemName: iconString)
                    }
                }
            }
        } else {
            Text("N/A")
                .foregroundColor(.gray)
        }
        
        ListMultiLineRow(title: "サブスキル", values: lily.subSkill) { skill in
            NavigationLink(destination: LilyListView(skillSelection: skill)) {
                HStack {
                    Spacer()
                    Text(skill)
                    if let iconString = Lily.subSkillLabelString(str: skill) {
                        Image(systemName: iconString)
                    }
                }
            }
        }
        
        if lily.isBoosted == true {
            ListMultiLineRow(title: "ブーステッドスキル", values: lily.boostedSkill) { skill in
                NavigationLink(destination: LilyListView(skillSelection: skill)) {
                    HStack {
                        Spacer()
                        Text(skill)
                        if let iconString = Lily.boostedSkillLabelString(str: skill) {
                            Image(systemName: iconString)
                                .foregroundColor("8b0000".convertToColor())
                        }
                    }
                }
            }
        }
        
        if lily.charm.count > 0 {
            DisclosureGroup(isExpanded: $charmExpanded) {
                ForEach(lily.charm) { lilyCharm in
                    NavigationLink(destination: CharmDetailView(resource: lilyCharm.charm.resource)) {
                        Text(self.charmText(lilyCharm: lilyCharm))
                            .frame(alignment: .trailing)
                    }
                }
            } label: {
                Text("使用CHARM")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            charmExpanded.toggle()
                        }
                    }
            }
        } else {
            HStack {
                Text("使用CHARM")
                Spacer()
                Text("N/A")
                    .foregroundColor(.gray)
            }
        }
    }
    
    func charmText(lilyCharm: LilyCharm) -> String {
        var charmTexts = ""
        if let pid = lilyCharm.charm.productID {
            charmTexts += "\(pid) "
        }
        if let name = lilyCharm.charm.name {
            charmTexts += "\(name) "
        }
        if lilyCharm.additinoalInformation.count > 0 {
            let infos = lilyCharm.additinoalInformation.joined(separator: ", ")
            charmTexts += "(\(infos))"
        }
        return charmTexts.trimmingCharacters(in: .whitespaces)
    }
}
