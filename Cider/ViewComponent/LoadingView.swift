//
//  LoadingView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/30.
//

import SwiftUI

struct LoadingView: View {
    @Binding var state: LoadingState
    let reloadAction: () -> Void
    
    var body: some View {
        if case .loading = self.state {
            Color(.systemBackground)
            ProgressView("Now Loading...")
                .progressViewStyle(CircularProgressViewStyle())
        } else if case .failure(let msg) = self.state {
            Color(.systemBackground)
            VStack(alignment: .center) {
                Spacer()
                Text(msg)
                Button(action: {
                    reloadAction()
                }, label: {
                    Text("再読み込み")
                        .padding(.all, 4)
                        .foregroundColor(.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lineWidth: 1.0)
                                .foregroundColor(.gray))
                })
                .padding(.vertical)
                Spacer()
            }
            .padding()
        } else {
            EmptyView()
        }
    }
}
