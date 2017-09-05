//
//  RegexExpression.swift
//  Pursuit
//
//  Created by ігор on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

struct RegexExpression {
    static func validateEmail(string: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: string)
    }
}
