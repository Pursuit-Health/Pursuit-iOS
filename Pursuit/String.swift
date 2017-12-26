//
//  String.swift
//  Pursuit
//
//  Created by ігор on 10/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

extension String {
    func persuitImageUrl() -> String {
        return "https://dev.nerdzlab.com" + self
    }
    
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
