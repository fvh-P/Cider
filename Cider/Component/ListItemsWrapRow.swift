//
//  ListItemsWrapRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/23.
//

import SwiftUI

struct ListItemsWrapRow: View {
    let title: String?
    let items: [String]?
    @State private var totalHeight = CGFloat.zero
    var body: some View {
        if let items = self.items, items.count > 0 {
            if let t = title {
                HStack {
                    Text(t)
                    Spacer()
                }
            }
            GeometryReader { geometry in
                self.generateContent(in: geometry, with: items, totalHeight: $totalHeight)
            }
            .frame(height: totalHeight)
            .padding(.leading, 15)
        }
        else {
            if let t = title {
                HStack {
                    Text(t)
                    Spacer()
                    Text("N/A")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
