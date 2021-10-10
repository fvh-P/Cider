//
//  LilyDetailIconAuthorInfoView.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/03.
//

import SwiftUI

struct LilyDetailIconAuthorInfoView: View {
    @ObservedObject var lilyDetailVM: LilyDetailViewModel
    @Environment(\.imageCache) var cache: ImageCache
    @Environment(\.openURL) var openURL
    var body: some View {
        Section(header: Text("アイコン情報")) {
            ForEach(self.lilyDetailVM.imageRecords) { imageRecord in
                HStack {
                    ImageView(url: imageRecord.imageUrl, cache: cache, placeholder: ImageIndicatorView(isAnimating: true))
                        .frame(height: 50)
                    VStack(alignment: .leading) {
                        Text("提供: \(imageRecord.author)さん")
                        if let twi = imageRecord.authorInfoDictionary["twitter"] {
                            Text("Twitter: @\(twi)")
                        }
                    }
                    Spacer()
                    if let pxv = imageRecord.authorInfoDictionary["pixiv"] {
                        Button(action: {
                            guard let appUrl = URL(string: "pixiv://\(pxv)") else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(appUrl) {
                                openURL(appUrl)
                            } else {
                                guard let webUrl = URL(string: "https://pixiv.net/\(pxv)") else {
                                    return
                                }
                                openURL(webUrl)
                            }
                        }, label: {
                            Image("PixivIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 32)
                                .padding(.horizontal, 8)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    if let twi = imageRecord.authorInfoDictionary["twitter"] {
                        Button(action: {
                            guard let appUrl = URL(string: "twitter://user?screen_name=\(twi)") else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(appUrl) {
                                openURL(appUrl)
                            } else {
                                guard let webUrl = URL(string: "https://twitter.com/\(twi)") else {
                                    return
                                }
                                openURL(webUrl)
                            }
                        }, label: {
                            Image("TwitterIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 32)
                                .padding(.horizontal, 8)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .font(.caption)
            }
        }
    }
}
