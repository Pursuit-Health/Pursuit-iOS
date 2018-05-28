//
//  Date.swift
//  Pursuit
//
//  Created by ігор on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return String(dateFormatter.string(from: self).capitalized.prefix(3))
    }
}

