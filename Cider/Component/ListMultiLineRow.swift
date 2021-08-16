//
//  ListMultiLineRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/27.
//

import SwiftUI

struct ListMultiLineRow: View {
    let title: String
    let values: [String]?
    @State var isExpanded = false
    var body: some View {
        if values != nil && values!.count > 0 {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(values!, id:\.self) { v in
                    HStack {
                        Spacer()
                        Text(v)
                    }
                }
                .padding(.bottom, 0.5)
            } label: {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }
            }
        } else {
            HStack {
                Text(title)
                Spacer()
                Text("N/A")
                    .foregroundColor(.gray)
            }
        }
    }
}

