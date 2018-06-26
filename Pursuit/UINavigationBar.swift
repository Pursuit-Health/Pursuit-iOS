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
        self.tintColor          = .clear
        self.setBackgroundImage(UIImage(), for: .default)
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font : UIFont(name: "Avenir-Book", size: 17.0)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        self.titleTextAttributes = attributes
    }
    
    func setTitleColor(_ color: UIColor) {
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "Avenir-Book", size: 18.0),
            NSAttributedStringKey.foregroundColor : color
        ]
        titleTextAttributes = attributes
    }
}
