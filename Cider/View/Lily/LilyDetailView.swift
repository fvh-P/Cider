//
//  LilyDetailView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/17.
//

import SwiftUI

struct LilyDetailView: View {
    var resource: String
    @State var lily: Lily?
    @State var charmExpanded: Bool = false
    var body: some View {
        List {
            Section(header: LilyDetailViewHeader(lily: lily)) {}
            Section(header: Text("ガーデン・レギオン情報")) {
                if let garden = lily?.garden {
                    ListSingleLineNavLinkRow(title: "所属ガーデン", value: garden, destination: AnyView(LilyListView(gardenSelection: garden)))
                } else {
                    ListSingleLineRow(title: "所属ガーデン", value: nil)
                }
                if let gardenDepartment = lily?.gardenDepartment {
                    ListSingleLineRow(title: "学科", value: gardenDepartment)
                }
                
                ListSingleLineRow(title: "学年", value: lily?.gradeString)
                
                if let gardenClass = lily?.gardenClass {
                    ListSingleLineRow(title: "クラス", value: gardenClass)
                }
                
                
                if lily != nil && lily!.gardenJobTitle.count > 0 {
                    ListMultiLineRow(title: "ガーデン役職", values: lily!.gardenJobTitle) { str in
                        HStack {
                            Spacer()
                            Text(str)
                        }
                    }
                }
                
                if let legionText = (lily?.legion?.name == nil)
                        ? nil
                        : (lily?.legion?.name)!
                            + (lily?.legion?.alternateName != nil
                                ? " (\((lily?.legion?.alternateName)!))"
                                : "") {
                    ListSingleLineNavLinkRow(title: "所属レギオン", value: legionText, destination: AnyView(LilyListView(legionSelection: lily?.legion?.name ?? "指定なし")))
                } else {
                    ListSingleLineRow(title: "所属レギオン", value: nil)
                }
                if lily != nil && lily!.legionJobTitle.count > 0 {
                    ListSingleLineRow(title: "レギオン役職", value: lily!.legionJobTitle.joined(separator: ", "))
                }
                
                let positionText = (lily != nil && (lily?.position.count)! > 0)
                    ? lily?.position.joined(separator: ", ")
                    : nil
                ListSingleLineRow(title: "ポジション", value: positionText)
            }
            Section(header: Text("基本情報")) {
                ListSingleLineRow(title: "年齢", value: lily?.age == nil ? nil : "\((lily?.age)!) 歳")
                ListSingleLineRow(title: "誕生日", value: lily?.birthDate == nil ? nil : lily?.birthDate!.stringFromDate(format: "M月d日"))
                ListSingleLineRow(title: "身長", value: lily?.height == nil ? nil : "\(Int((lily?.height)!)) cm")
                ListSingleLineRow(title: "体重", value: lily?.weight == nil ? nil : "\(Int((lily?.weight)!)) kg")
                ListSingleLineRow(title: "血液型", value: lily?.bloodType)
                ListSingleLineRow(title: "出身地", value: lily?.birthPlace)
                ListItemsWrapRow(title: "好きなもの", items: lily?.favorite)
                ListItemsWrapRow(title: "苦手なもの", items: lily?.notGood)
                ListItemsWrapRow(title: "趣味・特技", items: lily?.hobbyTalent)
            }
            Section(header: Text("スキル・CHARM情報")) {
                if let rareSkill = lily?.rareSkill {
                    NavigationLink(destination: LilyListView(skillSelection: rareSkill)) {
                        HStack {
                            Text("レアスキル")
                            Spacer()
                            Text(rareSkill)
                            if let iconString = lily?.rareSkillLabelString {
                                Image(systemName: iconString)
                            }
                        }
                    }
                } else {
                    Text("N/A")
                        .foregroundColor(.gray)
                }
                
                ListMultiLineRow(title: "サブスキル", values: lily?.subSkill) { skill in
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
                
                if lily?.isBoosted == true {
                    ListMultiLineRow(title: "ブーステッドスキル", values: lily?.boostedSkill) { skill in
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
                
                if lily?.charm != nil && lily!.charm.count > 0 {
                    DisclosureGroup(isExpanded: $charmExpanded) {
                        ForEach(lily!.charm) { lilyCharm in
                            NavigationLink(destination: CharmDetailView(resource: lilyCharm.charm.resource, charm: nil)) {
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
            
            if let relations = lily?.getAllRelations() {
                if relations.count > 0 {
                    Section(header: Text("関連する人物")) {
                        ForEach(relations) { rel in
                            RelationshipListRow(relation: rel)
                        }
                    }
                }
            }
            
            if let casts = lily?.cast {
                if casts.count > 0 {
                    Section(header: Text("キャスト情報")) {
                        ForEach(casts) { cast in
                            CastListRow(cast: cast)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(lily?.name ?? "読み込み中...")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.loadLilyDetail(resource: resource)
        }
    }
}
