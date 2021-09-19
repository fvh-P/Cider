//
//  ListSingleLineNavLinkRow.swift
//  Cider
//
//  Created by ふぁぼ腹 on 2021/09/16.
//

import SwiftUI

struct ListSingleLineNavLinkRow: View {
    let title: String?
    let value: String?
    let destination: AnyView
    var body: some View {
        NavigationLink(destination: destination) {
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
}
