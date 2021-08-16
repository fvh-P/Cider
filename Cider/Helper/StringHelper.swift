//
//  String+parse.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

import SwiftUI
import Foundation

extension String {
    public func parse<T: LosslessStringConvertible>() -> T? {
        guard let value = T(self) else {
            print("'\(self)' could not parse to \(T.self).")
            return nil
        }
        return value
    }
    
    public func dateFromString(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    public func convertToColor() -> Color? {
        var chars = Array(self.hasPrefix("#") ? self.dropFirst() : self[...])
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
        case 6:
            break
        default:
            return nil
        }
        return Color.init(red: Double(strtoul(String(chars[0...1]), nil, 16)) / 255.0,
                   green: Double(strtoul(String(chars[2...3]), nil, 16)) / 255.0,
                   blue: Double(strtoul(String(chars[4...5]), nil, 16)) / 255.0)
    }
}
