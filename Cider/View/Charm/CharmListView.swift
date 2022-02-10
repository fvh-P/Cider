//
//  CharmListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmListView: View {
    @EnvironmentObject var charmNavigationHelper: CharmNavigationHelper
    var isRootList = false
    @StateObject var charmListVM = CharmListViewModel()
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                List {
                    CharmListSearchBox(searchText: self.$charmListVM.searchText, searchExpanded: false)
                        .id(0)
                    
                    ForEach(self.charmListVM.filteredCharms) { charm in
                        if self.isRootList {
                            NavigationLink(destination: CharmDetailView(resource: charm.resource), tag: charm.resource, selection: self.$charmNavigationHelper.selection) {
                                CharmCardView(charm: charm)
                            }
                        } else {
                            NavigationLink(destination: CharmDetailView(resource: charm.resource)) {
                                CharmCardView(charm: charm)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("CHARM一覧")
                            .bold()
                            .padding(.horizontal, 20)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    proxy.scrollTo(0)
                                }
                            }
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    self.charmListVM.searchText = ""
                }) {
                    Text("絞り込み解除")
                })
            }
            
            LoadingView(state: self.$charmListVM.state) {
                self.charmListVM.loadCharmList()
            }
        }
        .onAppear { self.charmListVM.loadCharmList() }
        .navigationTitle("CHARM一覧")
    }
}
