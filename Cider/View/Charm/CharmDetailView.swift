//
//  CharmDetailView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmDetailView: View {
    var resource: String
    @State var charm: Charm?
    @State var expanded: [Bool]
    
    var body: some View {
        List {
            Section(header: CharmDetailViewHeader(charm: charm)) {}
            Section(header: Text("基本情報")) {
                ListSingleLineRow(title: "形式番号", value: charm?.productID)
                ListSingleLineRow(title: "名称", value: charm?.name)
                ListSingleLineRow(title: "Name", value: charm?.nameEn)
                ListSingleLineRow(title: "開発元", value: charm?.manufacturer?.name)
                let generation = charm?.generation == nil ? nil : "第\(charm!.generation!)世代"
                ListSingleLineRow(title: "世代", value: generation)
            }
            if charm != nil && (charm?.isVariantOf != nil || charm!.hasVariant.count > 0) {
                Section(header: Text("シリーズ情報")) {
                    if let parent = charm?.isVariantOf {
                        NavigationLink(destination: CharmDetailView(resource: parent.resource, charm: nil, expanded: [])) {
                            ListSingleLineRow(title: "派生元", value: parent.name ?? "名称不明")
                        }
                    }
                    if charm!.hasVariant.count > 0, let children = charm?.hasVariant {
                        ForEach(children) { child in
                            NavigationLink(destination: CharmDetailView(resource: child.resource, charm: nil, expanded: [])) {
                                ListSingleLineRow(title: "派生機体", value: child.name ?? "名称不明")
                            }
                        }
                    }
                }
            }
            if charm != nil && charm!.user.count > 0 {
                Section(header: Text("ユーザ情報")) {
                    if let users = charm?.user {
                        ForEach(0..<users.count) { i in
                            NavigationLink(destination: LilyDetailView(resource: users[i].resource)) {
                                HStack {
                                    Text(users[i].name ?? "N/A")
                                    Spacer()
                                }
                            }
                            let lilyCharm = users[i].charm.first
                            if let infos = lilyCharm?.additinoalInformation, infos.count > 0 {
                                ForEach(infos, id:\.self) { info in
                                    HStack {
                                        Text(info)
                                        Spacer()
                                    }
                                    .padding(.leading, 15)
                                }
                            }
                            if let usedIns = lilyCharm?.usedIn, usedIns.count > 0 {
                                ListMultiLineRow(title: "使用媒体", values: usedIns)
                                    .padding(.leading, 15)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(charm?.name ?? "読み込み中...")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.loadCharmDetail(resource: resource)
        }
    }
}
