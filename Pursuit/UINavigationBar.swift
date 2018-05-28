//
//  UINavigationBar.swift
//  Pursuit
//
//  Created by ігор on 8/16/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
     func setAppearence() {
        self.shadowImage        = UIImage()
        self.isTranslucent      = true
        self.backgroundColor    = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.clipsToBounds      = false
        self.tintColor          = .white
        self.setBackgroundImage(UIImage(), for: .default)
        let attributes: [String : Any] = [NSFontAttributeName : UIFont(name: "Avenir-Book", size: 17.0)!, NSForegroundColorAttributeName : UIColor.white]
        self.titleTextAttributes = attributes
    }
}
