//
//  ListSingleLineRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/26.
//

import SwiftUI

struct ListSingleLineRow: View {
    let title: String
    let value: String?
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let v = value {
                Text(v)
            } else {
                Text("N/A")
                    .foregroundColor(.gray)
            }
        }
    }
}
