//
//  DateHelper.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/22.
//

import SwiftUI

extension Date {
    public func stringFromDate(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
