//
//  DateHelper.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/22.
//

import SwiftUI

extension Date {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale = .current
        return calendar
    }
    
    var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }
    
    var isToday: Bool {
        calendar.isDateInToday(self.zeroclock)
    }
    
    var isTodayWithoutYear: Bool {
        calendar.isDateInToday(self.fixed(year: Self.now.year).zeroclock)
    }
    
    func stringFromDate(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year = year ?? self.year
        comp.month = month ?? self.month
        comp.day = day ?? self.day
        comp.hour = hour ?? self.hour
        comp.minute = minute ?? self.minute
        comp.second = second ?? self.second
        
        return calendar.date(from: comp)!
    }
    
    var year: Int {
        return calendar.component(.year, from: self)
    }
    
    var month: Int {
        return calendar.component(.month, from: self)
    }
    
    var day: Int {
        return calendar.component(.day, from: self)
    }
    
    var hour: Int {
        return calendar.component(.hour, from: self)
    }
    
    var minute: Int {
        return calendar.component(.minute, from: self)
    }
    
    var second: Int {
        return calendar.component(.second, from: self)
    }
    
    static var now: Date {
        return Date()
    }
    
    static var today: Date {
        return now.zeroclock
    }
}
