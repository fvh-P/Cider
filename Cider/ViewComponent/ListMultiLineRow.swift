//
//  ListMultiLineRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/27.
//

import SwiftUI

struct ListMultiLineRow<Content>: View where Content: View {
    let title: String
    let values: [String]?
    let content: (String) -> Content?
    @State var isExpanded = false
    var body: some View {
        if values != nil && values!.count > 0 {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(values!, id:\.self) { v in
                    self.content(v)
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
    
    init(title: String, values: [String]?, @ViewBuilder content: @escaping (String) -> Content? = {_ in nil}) {
        self.title = title
        self.values = values
        self.content = content
    }
}

