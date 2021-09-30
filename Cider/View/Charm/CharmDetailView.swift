//
//  CharmDetailView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmDetailView: View {
    var resource: String
    @StateObject var charmDetailVM = CharmDetailViewModel()
    
    var body: some View {
        ZStack {
            List {
                Section(header: CharmDetailViewHeader(charm: self.charmDetailVM.charm)) {}
                Section(header: Text("基本情報")) {
                    ListSingleLineRow(title: "形式番号", value: self.charmDetailVM.charm?.productID)
                    ListSingleLineRow(title: "名称", value: self.charmDetailVM.charm?.name)
                    ListSingleLineRow(title: "Name", value: self.charmDetailVM.charm?.nameEn)
                    ListSingleLineRow(title: "開発元", value: self.charmDetailVM.charm?.manufacturer?.name)
                    let generation = self.charmDetailVM.charm?.generation == nil ? nil : "第\(self.charmDetailVM.charm!.generation!)世代"
                    ListSingleLineRow(title: "世代", value: generation)
                }
                if self.charmDetailVM.charm != nil && (self.charmDetailVM.charm?.isVariantOf != nil || self.charmDetailVM.charm!.hasVariant.count > 0) {
                    Section(header: Text("シリーズ情報")) {
                        if let parent = self.charmDetailVM.charm?.isVariantOf {
                            NavigationLink(destination: CharmDetailView(resource: parent.resource)) {
                                ListSingleLineRow(title: "派生元", value: parent.name ?? "名称不明")
                            }
                        }
                        if self.charmDetailVM.charm!.hasVariant.count > 0, let children = self.charmDetailVM.charm?.hasVariant {
                            ForEach(children) { child in
                                NavigationLink(destination: CharmDetailView(resource: child.resource)) {
                                    ListSingleLineRow(title: "派生機体", value: child.name ?? "名称不明")
                                }
                            }
                        }
                    }
                }
                if self.charmDetailVM.charm != nil && self.charmDetailVM.charm!.user.count > 0 {
                    Section(header: Text("ユーザ情報")) {
                        if let users = self.charmDetailVM.charm?.user {
                            ForEach(users) { user in
                                CharmUserView(user: user)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(self.charmDetailVM.charm?.name ?? "読み込み中...")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.charmDetailVM.loadCharmDetail(resource: resource)
            }
            
            LoadingView(state: self.$charmDetailVM.state) {
                self.charmDetailVM.loadCharmDetail(resource: resource)
            }
        }
    }
}
