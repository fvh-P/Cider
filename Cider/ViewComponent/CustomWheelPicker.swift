//
//  CustomWheelPicker.swift
//  Cider
//
//  Created by ふぁぼ原 on 2022/02/11.
//

import SwiftUI

struct CustomWheelPicker<T: RawRepresentable>: UIViewRepresentable where T.RawValue == String, T: Equatable {
    var selection: Binding<T>
    let data: Array<T>
    let width: CGFloat
    
    init(selecting: Binding<T>, data: Array<T>, width: CGFloat = 90) {
        self.selection = selecting
        self.data = data
        self.width = width
    }
    
    func makeCoordinator() -> CustomWheelPicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomWheelPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<CustomWheelPicker>) {
        guard let row = data.firstIndex(of: selection.wrappedValue) else { return }
        view.selectRow(row, inComponent: 0, animated: false)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomWheelPicker
        
        init(_ pickerView: CustomWheelPicker) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return self.parent.width
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.data[row].rawValue
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection.wrappedValue = parent.data[row]
        }
    }
}
