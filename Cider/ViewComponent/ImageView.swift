//
//  ImageView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

import SwiftUI

struct ImageView<Placeholder: View>: View {
    @ObservedObject private var imageloader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, cache: ImageCache? = nil, placeholder: Placeholder? = nil) {
        self.imageloader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if self.imageloader.image != nil {
                Image(uiImage: self.imageloader.image!)
                    .resizable()
                    .scaledToFit()
            } else {
                self.placeholder
            }
        }
        .onAppear {
            imageloader.load()
        }
    }
}
