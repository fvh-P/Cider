//
//  LegionPicker.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

struct LegionPicker: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    @Binding var legionSelection: String
    var legions: [String]
    var body: some View {
        GeometryReader { gr in
            VStack {
                VStack {
                    Text("レギオンを選択")
                        .padding(.top, 10)
                    Picker(selection: $legionSelection, label: Text("レギオン")) {
                        ForEach(0 ..< legions.count) { i in
                            Text(legions[i]).tag(legions[i])
                        }
                    }
                    .onTapGesture {}
                }
                .frame(maxWidth: min(600, gr.size.width) - 10)
                .background(RoundedRectangle(cornerRadius: 16.0)
                                .foregroundColor(Color(.systemGray4))
                                .shadow(radius: 1.0))
                VStack {
                    Button(action: { self.sheetManager.closePartialSheet() }) {
                        Text("完了").fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: min(600, gr.size.width) - 10)
                            .background(RoundedRectangle(cornerRadius: 16.0)
                                            .foregroundColor(Color(.systemGray4))
                                            .shadow(radius: 1.0))
                    }
                }
            }
            .position(x: gr.size.width / 2, y: gr.size.height - 200)
        }
    }
}
