//
//  SkillPicker.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/30.
//

import SwiftUI

struct SkillPicker: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    @Binding var skillSelection: String
    @State var skillClass = 0
    @State var skillIndex = 0
    @State var tmpSelect = "指定なし"
    var skills: [[String]]
    var body: some View {
        GeometryReader { gr in
            VStack {
                VStack {
                    Text("スキルを選択")
                        .padding(.top, 10)
                    HStack {
                        Picker(selection: $skillClass, label: Text("スキル種別")) {
                            Text("レアスキル").tag(0)
                                .font(.callout)
                            Text("サブスキル").tag(1)
                                .font(.callout)
                            Text("ブーステッドスキル").tag(2)
                                .font(.callout)
                        }
                        .onTapGesture {}
                        .frame(maxWidth: min(600, gr.size.width) * 0.4 - 10)
                        .clipped()
                        Picker(selection: $skillSelection, label: Text("スキル")) {
                            ForEach(self.skills[self.skillClass], id:\.self) { item in
                                HStack {
                                    Text(item).tag(item)
                                    if let rareSkillIcon = Lily.rareSkillIcon(item) {
                                        rareSkillIcon
                                    } else if let subSkillIcon = Lily.subSkillIcon(item) {
                                        subSkillIcon
                                    } else if let boostedSkillIcon = Lily.boostedSkillIcon(item) {
                                        boostedSkillIcon
                                            .foregroundColor("8b0000".convertToColor())
                                    }
                                }
                                .font(.callout)
                            }
                        }
                        .onTapGesture {}
                        .frame(maxWidth: min(600, gr.size.width) * 0.6 - 10)
                        .clipped()
                    }
                }
                .frame(maxWidth: min(600, gr.size.width) - 10)
                .background(RoundedRectangle(cornerRadius: 16.0)
                                .foregroundColor(Color(.systemGray4))
                                .shadow(radius: 1.0))
                Button(action: { self.sheetManager.closePartialSheet() }) {
                    Text("完了").fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: min(600, gr.size.width) - 10)
                        .background(RoundedRectangle(cornerRadius: 16.0)
                                        .foregroundColor(Color(.systemGray4))
                                        .shadow(radius: 1.0))
                }
            }
            .position(x: gr.size.width / 2, y: gr.size.height - 200)
        }
    }
}
