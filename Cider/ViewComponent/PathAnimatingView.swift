//
//  PathAnimatingView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/23.
//

import SwiftUI

struct PathAnimatingView<Content>: UIViewRepresentable where Content: View {
    
    let path: Path
    var startDelay: Double = 0.0
    let content: () -> Content

    func makeUIView(context: UIViewRepresentableContext<PathAnimatingView>) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = CFTimeInterval(2)
        animation.path = path.cgPath
        animation.beginTime = CACurrentMediaTime() + startDelay
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        let sub = UIHostingController(rootView: content())
        sub.view.translatesAutoresizingMaskIntoConstraints = false
        sub.view.backgroundColor = .clear
        
        animation.delegate = LayerRemover(for: sub.view)

        view.addSubview(sub.view)
        sub.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sub.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.layer.add(animation, forKey: "pathAnimation")
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PathAnimatingView>) {
    }
    
    typealias UIViewType = UIView
}

class LayerRemover: NSObject, CAAnimationDelegate {
    private weak var view: UIView?
    init(for view: UIView) {
        self.view = view
        super.init()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        view?.removeFromSuperview()
    }
}

struct PathAnimationgView_Preview: PreviewProvider {
    static var previews: some View {
        PathAnimatingView(path: Path { p in
            p.move(to: CGPoint(x: CGFloat.random(in: 20...UIScreen.main.bounds.size.width - 20), y: UIScreen.main.bounds.size.height + 50))
            p.addLine(to: CGPoint(x: CGFloat.random(in: 20...UIScreen.main.bounds.size.width - 20), y: -50))
        }){
                    Image("balloon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                }
    }
}
