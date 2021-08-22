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
    
    func generateContent(in g: GeometryProxy, with items: [String], totalHeight: Binding<CGFloat>) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.item(for: item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item == items.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader(totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.callout)
            .background(RoundedRectangle(cornerRadius: 4.0)
                            .stroke())
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
