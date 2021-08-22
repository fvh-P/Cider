//
//  CharmUserView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/20.
//

import SwiftUI

struct CharmUserView: View {
    let user: Lily
    var body: some View {
        NavigationLink(destination: LilyDetailView(resource: user.resource)) {
            HStack {
                Text(user.name ?? "N/A")
                Spacer()
            }
        }
        let lilyCharm = user.charm.first
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
            ListItemsWrapRow(title: nil, items: usedIns)
        }
    }
}
