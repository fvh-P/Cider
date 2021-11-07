//
//  GardenPicker.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/29.
//

import SwiftUI

struct GardenPicker: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    @Binding var gardenSelection: String
    var gardens: [String]
    var body: some View {
        GeometryReader { gr in
            VStack {
                VStack {
                    Text("ガーデンを選択")
                        .padding(.top, 10)
                    Picker(selection: $gardenSelection, label: Text("ガーデン")) {
                        ForEach(0 ..< gardens.count) { i in
                            Text(gardens[i]).tag(gardens[i])
                        }
                    }
                    .pickerStyle(.wheel)
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
