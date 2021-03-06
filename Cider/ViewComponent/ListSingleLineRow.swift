//
//  ListSingleLineRow.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/07/26.
//

import SwiftUI

struct ListSingleLineRow: View {
    let title: String?
    let value: String?
    var body: some View {
        HStack {
            if let t = title {
                Text(t)
            }
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
