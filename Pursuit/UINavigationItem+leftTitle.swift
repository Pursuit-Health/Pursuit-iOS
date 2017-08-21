//
//  UINavigationItem.swift
//  Pursuit
//
//  Created by ігор on 8/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UINavigationItem {
    private static var left_text_key: UInt8 = 0
    private static var left_item_key: UInt8 = 1
    
    public var leftTitle: String? {
        set {
            objc_setAssociatedObject(self, &UINavigationItem.left_text_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            updateLeft(title: newValue ?? "")
        }
        
        get {
            return objc_getAssociatedObject(self, &UINavigationItem.left_text_key) as? String
        }
    }
    
    private func updateLeft(title: String) {
        
        let leftItem = self.createLeftItem()
        
        let nilItems: [UIBarButtonItem?]    = [self.leftBarButtonItem, leftItem]
        self.leftBarButtonItems             = nilItems.flatMap{ $0 }
        
        leftItem.hp_label.text              = title
        leftItem.hp_label.frame             = CGRect(origin: .zero, size: leftItem.hp_label.intrinsicContentSize)
    }
    
    private func createLeftItem() -> UIBarButtonItem {
        let leftItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return leftItem
    }
}
