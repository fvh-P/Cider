//
//  LilyDetailView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/17.
//

import SwiftUI

struct LilyDetailView: View, LilyRepositoryInjectable {
    var resource: String
    @StateObject var lilyDetailVM = LilyDetailViewModel()
    var body: some View {
        ZStack {
            List {
                Section(header: LilyDetailViewHeader(lily: self.lilyDetailVM.lily)) {}
                Section(header: Text("ガーデン・レギオン情報")) {
                    if let lily = self.lilyDetailVM.lily {
                        LilyDetailGardenLegionInfoView(lily: lily)
                    }
                }
                Section(header: Text("基本情報")) {
                    if let lily = self.lilyDetailVM.lily {
                        LilyDetailBasicInfoView(lily: lily)
                    }
                }
                Section(header: Text("スキル・CHARM情報")) {
                    if let lily = self.lilyDetailVM.lily {
                        LilyDetailSkillCharmView(lily: lily)
                    }
                }
                
                if let relations = self.lilyDetailVM.lily?.getAllRelations() {
                    if relations.count > 0 {
                        Section(header: Text("関連する人物")) {
                            ForEach(relations) { rel in
                                RelationshipListRow(relation: rel)
                            }
                        }
                    }
                }
                
                if let casts = self.lilyDetailVM.lily?.cast {
                    if casts.count > 0 {
                        Section(header: Text("キャスト情報")) {
                            ForEach(casts) { cast in
                                CastListRow(cast: cast)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(self.lilyDetailVM.lily?.name ?? "読み込み中...")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.lilyDetailVM.loadLilyDetail(resource: resource)
            }
            
            LoadingView(state: self.$lilyDetailVM.state) {
                self.lilyDetailVM.loadLilyDetail(resource: resource)
            }
        }
    }
}
