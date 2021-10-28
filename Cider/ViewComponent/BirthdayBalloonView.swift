//
//  BirthdayBalloonView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/23.
//

import SwiftUI

struct BirthdayBalloonView: View {
    @State private var hidden = true
    @State private var timer: Timer?
    let startDelay = Double.random(in: 0.1...3.0)
    let view: AnyView
    init(proxy: GeometryProxy) {
        self.view = AnyView(PathAnimatingView(path: Path { p in
            p.move(to: CGPoint(x: CGFloat.random(in: 20...proxy.size.width - 20), y: proxy.size.height + 100))
            p.addLine(to: CGPoint(x: CGFloat.random(in: 20...proxy.size.width - 20), y: -200))
        }) {
            Image("balloon")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .foregroundColor(.random.opacity(0.8))
        })
    }
    
    var body: some View {
        Group {
            if self.hidden {
                view.hidden()
            } else {
                view
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
                self.hidden = false
            }
        }
    }
}

struct BirthbayBalloonView_Preview: PreviewProvider {
    static var previews: some View {
        GeometryReader { gr in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Text("testtesttest")
                        .font(.largeTitle)
                    Text("testtesttest")
                        .font(.largeTitle)
                    Text("testtesttest")
                        .font(.largeTitle)
                    Text("testtesttest")
                        .font(.largeTitle)
                }
                Spacer()
            }
            ForEach(1...10, id:\.self) { _ in
                BirthdayBalloonView(proxy: gr)
            }
        }
    }
}
