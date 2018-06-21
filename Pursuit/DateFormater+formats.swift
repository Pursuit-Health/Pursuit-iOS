//
//  NSDateFormater+gcFormats.swift
//
//  Created by Igor on 08/17/17.
//  Copyright © 2016 GoodCards. All rights reserved.
//

import Foundation

struct DateFormatters {
    static let serverTimeFormatter: DateFormatter       = DateFormatters.dateFormatterWith("yyyy-MM-dd")
    static let projectFormatFormatter: DateFormatter    = DateFormatters.dateFormatterWith("yyyy MM dd")
    static let createEditFormatFormatter: DateFormatter = DateFormatters.dateFormatterWith("dd/MM/yyyy")
    static let fullFormat: DateFormatter                = DateFormatters.dateFormatterWith("yyyy-MM-dd HH:mm:ss +zzzz")
    static let monthYearFormat: DateFormatter           = DateFormatters.dateFormatterWith("MMMM yyyy")
    static let serverHoursFormatter: DateFormatter      = DateFormatters.dateFormatterWith("HH:mm")
    
    static func defaultFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    }
    
    static func dateFormatterWith(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatters.defaultFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }
}
