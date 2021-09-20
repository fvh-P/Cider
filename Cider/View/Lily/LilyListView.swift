//
//  LilyListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

struct LilyListView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State var searchText: String = ""
    @State var gardenSelection = "指定なし"
    @State var showGardenPicker = false
    @State var legionSelection = "指定なし"
    @State var showLegionPicker = false
    @State var skillSelection = "指定なし"
    @State var showSkillPicker = false
    @State var lilies: [Lily]

    var body: some View {
        List {
            LilyListSearchBox(searchText: $searchText, gardenSelection: $gardenSelection, legionSelection: $legionSelection, skillSelection: $skillSelection, gardens: gardens, legions: legions, skills: skills)

            ForEach(filteredLilies) { lily in
                NavigationLink(destination: LilyDetailView(resource: lily.resource, lily: nil)) {
                    LilyCardView(lily: lily)
                }
            }
        }
        .navigationTitle("リリィ一覧")
        .navigationBarItems(trailing: Button(action: {
            self.searchText = ""
            self.gardenSelection = "指定なし"
            self.legionSelection = "指定なし"
            self.skillSelection = "指定なし"
        }) {
            Text("絞り込み解除")
        })
        .edgesIgnoringSafeArea(.all)
        .onAppear { self.loadLilyList() }
        
        .addPartialSheet(style: PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground).opacity(0.0)), accentColor: Color.accentColor.opacity(0.0), enableCover: false, coverColor: Color.gray.opacity(0.0), cornerRadius: 16.0, minTopDistance: 100))
    }
}
