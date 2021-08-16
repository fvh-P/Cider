//
//  CharmDetailViewHeader.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/08/09.
//

import SwiftUI

struct CharmDetailViewHeader: View {
    var charm: Charm?
    var body: some View {
        VStack {
            HStack {
                if let productID = charm?.productID {
                    Text(productID)
                        .font(.callout)
                }
                Spacer()
            }
            .frame(alignment: .leading)
            .padding(.top, 10)
            
            HStack {
                if let name = charm?.name {
                    Text(name)
                        .font(.title2)
                } else {
                    Text("名前情報なし")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .frame(alignment: .leading)
            
            HStack {
                if let nameEn = charm?.nameEn {
                    Text(nameEn)
                        .font(.callout)
                        .frame(alignment: .leading)
                } else {
                    Text("No reading information")
                        .font(.callout)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            HStack {
                if let seriesName = charm?.seriesName, let _ = charm?.isVariantOf {
                    Text("\(seriesName) シリーズ")
                        .padding(.top, 5)
                }
                Spacer()
            }

            if charm != nil && charm!.additionalInformation.count > 0 {
                VStack {
                    ForEach(charm!.additionalInformation, id:\.self) { info in
                        HStack {
                            Text(info)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
            }
        }
        .foregroundColor(.primary)
        .textCase(.none)
    }
}
