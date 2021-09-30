//
//  CharmListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmListView: View {
    @StateObject var charmListVM = CharmListViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    CharmListSearchBox(searchText: self.$charmListVM.searchText, searchExpanded: false)
                    ForEach(self.charmListVM.filteredCharms) { charm in
                        NavigationLink(destination: CharmDetailView(resource: charm.resource)) {
                            CharmCardView(charm: charm)
                        }
                    }
                }
                .navigationTitle("CHARM一覧")
                .navigationBarItems(trailing: Button(action: {
                    self.charmListVM.searchText = ""
                }) {
                    Text("絞り込み解除")
                })
                .edgesIgnoringSafeArea(.all)
                
                LoadingView(state: self.$charmListVM.state) {
                    self.charmListVM.loadCharmList()
                }
            }
        }
        .modifier(ResponsiveNavigationStyle())
        .onAppear { self.charmListVM.loadCharmList() }
        .addPartialSheet(style: PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground).opacity(0.0)), accentColor: Color.accentColor.opacity(0.0), enableCover: false, coverColor: Color.gray.opacity(0.0), cornerRadius: 16.0, minTopDistance: 100))
    }
}
