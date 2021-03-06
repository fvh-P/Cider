//
//  LilyCardView.swift
//  Cider
//
//  Created by ãµããŒå on 2021/07/15.
//

import SwiftUI

struct LilyCardView: View {
    let lily: Lily
    @Binding var sortOption: LilyListViewModel.SortOption
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if lily.birthDate != nil && lily.birthDate!.stringFromDate(format: "--MM-dd") == Date().stringFromDate(format: "--MM-dd") {
                    Text("ð")
                }
                Text(lily.name ?? "åç§°äžæãªãªã£")
                    .font(.headline)
            }
            Spacer()
            if let birthDate = lily.birthDate, (sortOption == .birthDate || sortOption == .birthDateFromToday) {
                Text("èªçæ¥: \(birthDate.stringFromDate(format: "Mædæ¥"))")
                    .font(.caption)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("\(lily.garden ?? "æå±äžæ") \(lily.gradeString ?? "")")
                    Spacer()
                    Text("\(lily.legion != nil && lily.legion?.name != nil ? "LG " + (lily.legion?.name)! : "ã¬ã®ãªã³æå ±ãªã")")
                }
                Spacer()
                if let rareSkill = lily.rareSkill {
                    Text(rareSkill)
                    if let rareSkillIcon = Lily.rareSkillIcon(rareSkill) {
                        rareSkillIcon
                    }
                }
                else {
                    Text("\(lily.rareSkill ?? "ã¬ã¢ã¹ã­ã«äžæ")")
                }
            }
            .font(.caption)
        }
        .padding(.all, 5)
    }
}

struct LilyCardView_Preview: PreviewProvider {
    static var previews: some View {
        LilyCardView(lily: Lily(), sortOption: Binding<LilyListViewModel.SortOption>.constant(.nameKana))
    }
}
