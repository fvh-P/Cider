//
//  CharmListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmListView: View {
    @State var searchText: String = ""
    @State var charms: [Charm]
    var body: some View {
        NavigationView {
            List {
                CharmListSearchBox(searchText: $searchText, searchExpanded: false)
                ForEach(filteredCharms) { charm in
                    NavigationLink(destination: CharmDetailView(resource: charm.resource, charm: nil)) {
                        CharmCardView(charm: charm)
                    }
                }
            }
            .navigationTitle("CHARM一覧")
            .navigationBarItems(trailing: Button(action: {
                self.searchText = ""
            }) {
                Text("絞り込み解除")
            })
            .edgesIgnoringSafeArea(.all)
        }
        .modifier(ResponsiveNavigationStyle())
        .onAppear { self.loadCharmList() }
        .addPartialSheet(style: PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground).opacity(0.0)), accentColor: Color.accentColor.opacity(0.0), enableCover: false, coverColor: Color.gray.opacity(0.0), cornerRadius: 16.0, minTopDistance: 100))
    }
}
