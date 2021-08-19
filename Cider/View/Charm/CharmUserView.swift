//
//  CharmUserView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/20.
//

import SwiftUI

struct CharmUserView: View {
    let user: Lily
    @State private var totalHeight = CGFloat.zero
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
            VStack {
                GeometryReader { geometry in
                    self.generateContent(in: geometry, with: usedIns)
                }
            }
            .frame(height: totalHeight)
            .padding(.leading, 15)
        }
    }
    
    private func generateContent(in g: GeometryProxy, with usedIns: [String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(usedIns, id: \.self) { usedIn in
                self.item(for: usedIn)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if usedIn == usedIns.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if usedIn == usedIns.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
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
