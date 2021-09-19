//
//  CharmListSearchBox.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/10.
//

import SwiftUI

struct CharmListSearchBox: View {
    @Binding var searchText: String
    @State var searchExpanded = false
    var body: some View {
        DisclosureGroup(
            isExpanded: $searchExpanded,
            content: {
                HStack {
                    Text("名前: ")
                    TextField("", text: $searchText)
                        .placeholder(when: self.searchText.isEmpty) {
                            Text("名前の一部を入力")
                                .foregroundColor(Color(.systemGray3))
                        }
                }
            },
            label: {
                Text("絞り込み")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            self.searchExpanded.toggle()
                        }
                    }
            })
    }
}
