//
//  NSDateFormater+gcFormats.swift
//
//  Created by Igor on 08/17/17.
//  Copyright © 2016 GoodCards. All rights reserved.
//

import Foundation

struct DateFormatters {
    static let serverTimeFormatter: DateFormatter = DateFormatters.dateFormatterWith("yyyy-MM-dd HH:mm")
    static let projectFormatFormatter: DateFormatter = DateFormatters.dateFormatterWith("yyyy MM dd")
    static let createEditFormatFormatter: DateFormatter = DateFormatters.dateFormatterWith("dd/MM/yyyy")
    static let fullFormat: DateFormatter = DateFormatters.dateFormatterWith("yyyy-MM-dd HH:mm:ss +zzzz")
    
    static func defaultFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        return dateFormatter
    }
    
    static func dateFormatterWith(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatters.defaultFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
