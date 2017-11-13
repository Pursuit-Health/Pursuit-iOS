//
//  UIApplication+StatusBar.swift
//  Pursuit
//
//  Created by ігор on 11/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

extension UIApplication {
        var statusBarView: UIView? {
            UIApplication.shared.isStatusBarHidden = false
            return value(forKey: "statusBar") as? UIView
        }
}
