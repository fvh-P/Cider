//
//  LilyDetailGardenLegionInfoView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/26.
//

import SwiftUI

struct LilyDetailGardenLegionInfoView: View {
    let lily: Lily
    var body: some View {
        if let garden = lily.garden {
            ListSingleLineNavLinkRow(title: "所属ガーデン", value: garden, destination: AnyView(LilyListView(gardenSelection: garden)))
        } else {
            ListSingleLineRow(title: "所属ガーデン", value: nil)
        }
        if let gardenDepartment = lily.gardenDepartment {
            ListSingleLineRow(title: "学科", value: gardenDepartment)
        }
        
        ListSingleLineRow(title: "学年", value: lily.gradeString)
        
        if let gardenClass = lily.gardenClass {
            ListSingleLineRow(title: "クラス", value: gardenClass)
        }
        
        
        if lily.gardenJobTitle.count > 0 {
            ListMultiLineRow(title: "ガーデン役職", values: lily.gardenJobTitle) { str in
                HStack {
                    Spacer()
                    Text(str)
                }
            }
        }
        
        if let legionText = (lily.legion?.name == nil)
                ? nil
                : (lily.legion?.name)!
                    + (lily.legion?.alternateName != nil
                        ? " (\((lily.legion?.alternateName)!))"
                        : "") {
            ListSingleLineNavLinkRow(title: "所属レギオン", value: legionText, destination: AnyView(LilyListView(legionSelection: lily.legion?.name ?? "指定なし")))
        } else {
            ListSingleLineRow(title: "所属レギオン", value: nil)
        }
        if lily.legionJobTitle.count > 0 {
            ListSingleLineRow(title: "レギオン役職", value: lily.legionJobTitle.joined(separator: ", "))
        }
        
        let positionText = ((lily.position.count) > 0)
            ? lily.position.joined(separator: ", ")
            : nil
        ListSingleLineRow(title: "ポジション", value: positionText)
    }
}
