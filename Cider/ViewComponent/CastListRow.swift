//
//  CastListRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/06.
//

import SwiftUI

struct CastListRow: View {
    var cast: LilyCast
    @State var isExpanded = false
    var body: some View {
        if cast.performIn.count > 0 {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(cast.performIn) { p in
                    HStack {
                        if let genre = p.getGenre() {
                            Text("\(genre) ")
                        }
                        Spacer()
                        Text(p.getName(getShortNameWhenLong: true) ?? "N/A")
                    }
                }
                .padding(.bottom, 0.5)
            } label: {
                Text(cast.name ?? "N/A")
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
                Spacer()
                Text(cast.name ?? "N/A")
            }
        }
    }
}
