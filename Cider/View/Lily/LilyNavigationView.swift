//
//  LilyNavigationView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/21.
//

import SwiftUI

struct LilyNavigationView: View {
    var body: some View {
        NavigationView {
            LilyListView(lilies: [])
        }
        .modifier(ResponsiveNavigationStyle())
    }
}
