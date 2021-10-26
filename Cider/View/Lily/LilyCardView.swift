//
//  LilyCardView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

struct LilyCardView: View {
    private let customRareSkillSymbolConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .medium, scale: .small)
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
                if lily.rareSkillLabelString != nil {
                    Text("\(lily.rareSkill ?? "レアスキル不明")")
                    if lily.rareSkill == "ユーバーザイン" {
                        Image(uiImage: UIImage(named: "aqi.medium", in: nil, with: customRareSkillSymbolConfig)!.withRenderingMode(.alwaysTemplate).withTintColor(UIColor(Color.primary)))
                            .resizable()
                            .aspectRatio(0.9, contentMode: .fit)
                            .frame(height: 15.0)
                    }
                    else {
                        Image(systemName: lily.rareSkillLabelString!)
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
