//
//  Date+.swift
//  chef
//
//  Created by MataraiKaoru on 2019/11/26.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

extension Date {

    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale   = .current
        return calendar
    }

    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar

        var comp = DateComponents()
        comp.year   = year   ?? calendar.component(.year,   from: self)
        comp.month  = month  ?? calendar.component(.month,  from: self)
        comp.day    = day    ?? calendar.component(.day,    from: self)
        comp.hour   = hour   ?? calendar.component(.hour,   from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)

        return calendar.date(from: comp)!
    }

    var oclock: Date {
        return fixed(minute: 0, second: 0)
    }

    var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }

    func monthAsString() -> String {
                let df = DateFormatter()
                df.setLocalizedDateFormatFromTemplate("MMM")
                return df.string(from: self)
    }
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

