//
//  CharmNavigationView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/13.
//

import SwiftUI

struct CharmNavigationView: View {
    var body: some View {
        NavigationView {
            CharmListView(isRootList: true)
            Text("一覧からCHARMを選択してください")
        }
        .modifier(ResponsiveNavigationStyle())
        .addPartialSheet(style: PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground).opacity(0.0)), accentColor: Color.accentColor.opacity(0.0), enableCover: false, coverColor: Color.gray.opacity(0.0), cornerRadius: 16.0, minTopDistance: 100))
    }
}
