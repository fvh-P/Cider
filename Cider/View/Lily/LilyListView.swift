//
//  LilyListView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI

struct LilyListView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var gardenSelection = "指定なし"
    var legionSelection = "指定なし"
    var skillSelection = "指定なし"
    @StateObject var lilyListVM = LilyListViewModel()
    
    var body: some View {
        ZStack{
            List {
                LilyListSearchBox(lilyListVM: self.lilyListVM)
                
                ForEach(self.lilyListVM.filteredLilies) { lily in
                    NavigationLink(destination: LilyDetailView(resource: lily.resource)) {
                        LilyCardView(lily: lily)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("リリィ一覧")
            .navigationBarItems(trailing: Button(action: {
                self.lilyListVM.resetSelections()
            }) {
                Text("絞り込み解除")
            })
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
    }
}
