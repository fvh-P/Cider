//
//  LilyDetailViewHeader.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/07/27.
//

import SwiftUI

struct LilyDetailViewHeader: View {
    @ObservedObject var lilyDetailVM: LilyDetailViewModel
    @Environment(\.imageCache) var cache: ImageCache
    var lily: Lily? {
        self.lilyDetailVM.lily
    }
    var icon: [ImageRecord] {
        self.lilyDetailVM.imageRecords.filter{ $0.type == "icon" }
    }
    var body: some View {
        VStack {
            if lily?.birthDate != nil && lily!.birthDate!.stringFromDate(format: "--MM-dd") == Date().stringFromDate(format: "--MM-dd") {
                Text("π Happy Birthday!")
                    .font(.title3)
            }
            if let icon = icon.randomElement() {
                HStack {
                    ImageView(url: icon.imageUrl, cache: cache, placeholder: ImageIndicatorView(isAnimating: true))
                        .frame(height: 100, alignment: .leading)
                    Spacer()
                }
            }
            HStack {
                if let name = lily?.name {
                    Text(name)
                        .font(.title2)
                        .frame(alignment: .leading)
                } else {
                    Text("εεζε ±γͺγ")
                        .font(.title2)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                if let nameKana = lily?.nameKana {
                    Text(nameKana)
                        .font(.callout)
                        .frame(alignment: .leading)
                } else {
                    Text("γγΏζε ±γͺγ")
                        .font(.callout)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.top, 1)
            
            HStack {
                if let nameEn = lily?.nameEn {
                    Text(nameEn)
                        .font(.callout)
                        .frame(alignment: .leading)
                } else {
                    Text("No reading information")
                        .font(.callout)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            if lily?.anotherName.isEmpty == false {
                HStack {
                    ForEach((lily?.anotherName)!, id:\.self) { anotherName in
                        Text("γ\(anotherName)γ")
                            .font(.callout)
                            .padding(EdgeInsets(top: 1, leading: -8, bottom: 0, trailing: -8))
                            .lineLimit(1)
                    }
                }
            }
            
            if lily?.rareSkill != nil && lily?.rareSkill != "ζͺθ¦ι" {
                HStack {
                    VStack {
                        if let rareSkillIcon = Lily.rareSkillIcon(lily?.rareSkill) {
                            rareSkillIcon
                        }
                        Text((lily?.rareSkill)!)
                    }
                    .font(.headline)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 4.0)
                                    .stroke(lineWidth: 2))
                }
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
            }
            
            if lily?.isBoosted == true || lily?.lifeStatus == "dead" {
                HStack {
                    if lily?.isBoosted == true {
                        let boostedColor = "8b0000".convertToColor()!
                        Text("εΌ·εγͺγͺγ£")
                            .font(.callout)
                            .foregroundColor(boostedColor.accessibleFontColor)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 4.0)
                                            .fill(boostedColor))
                    }
                    
                    if lily?.lifeStatus == "dead" {
                        Text("ζδΊΊ")
                            .font(.callout)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 4.0)
                                            .fill(Color.primary))
                        if let killedIn = lily?.killedIn {
                            Text("ζ¦ζ­»γ»ζ?θ·: \(killedIn)")
                                .font(.callout)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 4.0)
                                                .fill(Color.primary))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 1)
            }
        }
        .foregroundColor(.primary)
        .textCase(.none)
    }
}
