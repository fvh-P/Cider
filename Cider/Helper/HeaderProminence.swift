//
//  HeaderProminence.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/11/08.
//

import SwiftUI

struct HeaderProminence: ViewModifier {
    let prominence: CustomProminence
    
    init(_ prom: CustomProminence) {
        self.prominence = prom
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            if prominence == .increased {
                content
                    .headerProminence(.increased)
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 5)
            }
            else {
                content
                    .headerProminence(.standard)
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 5)
            }
        }
        else {
            content
        }
    }
    
    enum CustomProminence {
        case increased
        case standard
    }
}
