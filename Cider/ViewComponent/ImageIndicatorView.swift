//
//  ImageIndicatorView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

import SwiftUI

struct ImageIndicatorView: UIViewRepresentable {
    let isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        
        return indicatorView
    }
    
    func updateUIView(_ indicatorView: UIActivityIndicatorView, context: Context) {
        isAnimating ? indicatorView.startAnimating() : indicatorView.stopAnimating()
    }
}
