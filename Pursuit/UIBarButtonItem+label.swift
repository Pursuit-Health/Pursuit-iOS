//
//  UIBarButton+label.swift
//  Pursuit
//
//  Created by ігор on 8/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    private static var label_key: UInt8 = 0
    
    var hp_label: UILabel {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem.label_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            guard let leftLabel = objc_getAssociatedObject(self, &UIBarButtonItem.label_key) as? UILabel else {
                let titleLabel          = UILabel()
                titleLabel.font         = UIFont(name: "Avenir-Book", size: 17.0)
                titleLabel.bounds       = CGRect(x: 0, y: 0, width: 200, height: 40)
                titleLabel.textColor    = .white
                
                self.customView         = titleLabel
                self.hp_label           = titleLabel
                
                return titleLabel
            }
            return leftLabel
        }
    }
}
