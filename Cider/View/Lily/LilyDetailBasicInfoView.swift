//
//  LilyDetailBasicInfoView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/26.
//

import SwiftUI

struct LilyDetailBasicInfoView: View {
    let lily: Lily
    var body: some View {
        ListSingleLineRow(title: "年齢", value: lily.age == nil ? nil : "\((lily.age)!) 歳")
        ListSingleLineRow(title: "誕生日", value: lily.birthDate == nil ? nil : lily.birthDate!.stringFromDate(format: "M月d日"))
        ListSingleLineRow(title: "身長", value: lily.height == nil ? nil : "\(Int((lily.height)!)) cm")
        ListSingleLineRow(title: "体重", value: lily.weight == nil ? nil : "\(Int((lily.weight)!)) kg")
        ListSingleLineRow(title: "血液型", value: lily.bloodType)
        ListSingleLineRow(title: "出身地", value: lily.birthPlace)
        ListItemsWrapRow(title: "好きなもの", items: lily.favorite)
        ListItemsWrapRow(title: "苦手なもの", items: lily.notGood)
        ListItemsWrapRow(title: "趣味・特技", items: lily.hobbyTalent)
    }
}
