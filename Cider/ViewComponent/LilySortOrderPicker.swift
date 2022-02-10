//
//  LilySortOrderPicker.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/11/03.
//

import SwiftUI

struct LilySortOrderPicker: View {
    @EnvironmentObject var sheetManager: PartialSheetManager
    @Binding var sortOption: LilyListViewModel.SortOption
    @Binding var sortOrder: LilyListViewModel.SortOrder
    var body: some View {
        GeometryReader { gr in
            VStack {
                VStack {
                    Text("並び替えを選択")
                        .padding(.top, 10)
                    HStack(spacing: 0) {
                        CustomWheelPicker<LilyListViewModel.SortOption>(selecting: $sortOption, data: LilyListViewModel.SortOption.allCases, width: 200)
                            .onTapGesture { }
                            .frame(maxWidth: min(600, gr.size.width) * 0.7 - 5)
                        CustomWheelPicker<LilyListViewModel.SortOrder>(selecting: $sortOrder, data: LilyListViewModel.SortOrder.allCases)
                            .onTapGesture { }
                            .frame(maxWidth: min(600, gr.size.width) * 0.3 - 5)
//                        Picker(selection: $sortOption, label: Text("項目")) {
//                            ForEach(LilyListViewModel.SortOption.allCases, id:\.self) { option in
//                                Text(option.rawValue).tag(option)
//                            }
//                        }
//                        .pickerStyle(.wheel)
//                        .onTapGesture {}
//                        .frame(maxWidth: min(600, gr.size.width) * 0.7 - 10)
//                        .compositingGroup()
//                        .clipped(antialiased: true)
//                        Picker(selection: $sortOrder, label: Text("順序")) {
//                            ForEach(LilyListViewModel.SortOrder.allCases, id:\.self) { order in
//                                Text(order.rawValue).tag(order)
//                            }
//                        }
//                        .pickerStyle(.wheel)
//                        .onTapGesture {}
//                        .frame(maxWidth: min(600, gr.size.width) * 0.3 - 10)
//                        .compositingGroup()
//                        .clipped(antialiased: true)
                    }
                }
                .frame(maxWidth: min(600, gr.size.width) - 10)
                .background(RoundedRectangle(cornerRadius: 16.0)
                                .foregroundColor(Color(.systemGray4))
                                .shadow(radius: 1.0))
                Button(action: { self.sheetManager.closePartialSheet() }) {
                    Text("完了").fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: min(600, gr.size.width) - 10)
                        .background(RoundedRectangle(cornerRadius: 16.0)
                                        .foregroundColor(Color(.systemGray4))
                                        .shadow(radius: 1.0))
                }
            }
            .position(x: gr.size.width / 2, y: gr.size.height - 200)
        }
    }
}
