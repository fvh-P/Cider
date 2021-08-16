//
//  CharmCardView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmCardView: View {
    var charm: Charm
    var body: some View {
        VStack(alignment: .leading) {
            if let productID = charm.productID {
                Text(productID)
                    .font(.caption)
            }
            Text(charm.name ?? "名称不明CHARM")
                .font(.headline)
            Text(charm.nameEn ?? "No reading Information")
                .font(.caption)
            HStack {
                Text("開発元: ")
                if let manufacturerName = charm.manufacturer?.name {
                    Text(manufacturerName)
                } else {
                    Text("N/A")
                        .foregroundColor(.gray)
                }
            }
            .font(.subheadline)
            .padding(.top, 1)
        }
        .padding(.all, 5)
    }
}
