//
//  ResponsiveNavigationStyle.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/07/27.
//

import SwiftUI

struct ResponsiveNavigationStyle: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if horizontalSizeClass == .compact {
            content.navigationViewStyle(StackNavigationViewStyle())
        } else {
            content.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}
