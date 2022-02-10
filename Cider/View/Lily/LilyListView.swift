//
//  LilyListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

struct LilyListView: View {
    var isRootList = false
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @EnvironmentObject var lilyNavigationHelper: LilyNavigationHelper
    var gardenSelection: String? = nil
    var legionSelection: String? = nil
    var skillSelection: String? = nil
    @StateObject var lilyListVM = LilyListViewModel()
    
    var body: some View {
        ZStack{
            ScrollViewReader { proxy in
                List {
                    LilyListSearchBox(lilyListVM: self.lilyListVM)
                        .id(0)
                    
                    ForEach(self.lilyListVM.filteredLilies) { lily in
                        if isRootList {
                            NavigationLink(destination: LilyDetailView(resource: lily.resource), tag: lily.resource, selection: self.$lilyNavigationHelper.selection) {
                                LilyCardView(lily: lily, sortOption: self.$lilyListVM.sortOption)
                            }
                        } else {
                            NavigationLink(destination: LilyDetailView(resource: lily.resource)) {
                                LilyCardView(lily: lily, sortOption: self.$lilyListVM.sortOption)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("リリィ一覧")
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
                    self.lilyListVM.resetSelections()
                }) {
                    Text("絞り込み解除")
                })
            }
            .onAppear {
                if let gs = self.gardenSelection {
                    self.lilyListVM.gardenSelection = gs
                }
                if let ls = self.legionSelection {
                    self.lilyListVM.legionSelection = ls
                }
                if let ss = self.skillSelection {
                    self.lilyListVM.skillSelection = ss
                }
                self.lilyListVM.loadLilyList()
            }
            
            LoadingView(state: self.$lilyListVM.state) {
                self.lilyListVM.loadLilyList()
            }
        }
        .navigationTitle("リリィ一覧")
    }
}

struct LilyListView_Preview: PreviewProvider {
    static var previews: some View {
        LilyListView(isRootList: true)
            .environmentObject(PartialSheetManager())
            .environmentObject(LilyNavigationHelper())
    }
}
