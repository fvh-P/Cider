//
//  ListItemsWrapRow.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/23.
//

import SwiftUI

struct ListItemsWrapRow: View {
    let title: String?
    let items: [String]?
    @State private var totalHeight = CGFloat.zero
    var body: some View {
        if let items = self.items, items.count > 0 {
            if let t = title {
                HStack {
                    Text(t)
                    Spacer()
                }
            }
            GeometryReader { geometry in
                self.generateContent(in: geometry, with: items, totalHeight: $totalHeight)
            }
            .frame(height: totalHeight)
            .padding(.leading, 15)
        }
        else {
            if let t = title {
                HStack {
                    Text(t)
                    Spacer()
                    Text("N/A")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    func generateContent(in g: GeometryProxy, with items: [String], totalHeight: Binding<CGFloat>) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var prevHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .padding(.all, 5)
                    .font(.callout)
                    .background(RoundedRectangle(cornerRadius: 4.0)
                                    .stroke())
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= prevHeight
                        }
                        let result = width
                        if item == items.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        prevHeight = d.height
                        let result = height
                        if item == items.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader(totalHeight))
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
