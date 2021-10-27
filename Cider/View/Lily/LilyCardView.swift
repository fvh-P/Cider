//
//  LilyCardView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

struct LilyCardView: View {
    let lily: Lily
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if lily.birthDate != nil && lily.birthDate!.stringFromDate(format: "--MM-dd") == Date().stringFromDate(format: "--MM-dd") {
                    Text("🎉")
                }
                Text(lily.name ?? "名称不明リリィ")
                    .font(.headline)
            }
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("\(lily.garden ?? "所属不明") \(lily.gradeString ?? "")")
                    Spacer()
                    Text("\(lily.legion != nil && lily.legion?.name != nil ? "LG " + (lily.legion?.name)! : "レギオン情報なし")")
                }
                Spacer()
                if let rareSkill = lily.rareSkill {
                    Text(rareSkill)
                    if let rareSkillIcon = Lily.rareSkillIcon(rareSkill) {
                        rareSkillIcon
                    }
                }
                else {
                    Text("\(lily.rareSkill ?? "レアスキル不明")")
                }
            }
            .font(.caption)
        }
        .padding(.all, 5)
    }
}

struct LilyCardView_Preview: PreviewProvider {
    static var previews: some View {
        LilyCardView(lily: Lily())
    }
}
