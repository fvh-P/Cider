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
    var gardenSelection = "指定なし"
    var legionSelection = "指定なし"
    var skillSelection = "指定なし"
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
                                LilyCardView(lily: lily)
                            }
                        } else {
                            NavigationLink(destination: LilyDetailView(resource: lily.resource)) {
                                LilyCardView(lily: lily)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
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
                self.lilyListVM.gardenSelection = self.gardenSelection
                self.lilyListVM.legionSelection = self.legionSelection
                self.lilyListVM.skillSelection = self.skillSelection
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
