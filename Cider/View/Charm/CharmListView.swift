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
    }
}
