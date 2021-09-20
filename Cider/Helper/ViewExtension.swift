//
//  ViewExtension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when showldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(showldShow ? 1 : 0)
            self
        }
    }
}
