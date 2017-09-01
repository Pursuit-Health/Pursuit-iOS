//
//  NSLayoutConstraint.swift
//  Pursuit
//
//  Created by ігор on 8/31/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UITextField {
    func animateText(constraint: NSLayoutConstraint, isSelected: Bool) {
        constraint.constant = isSelected ? 20 : -20
        
        UIView.animate(withDuration: 0.9) { [unowned self] in
            self.layer.layoutIfNeeded()
        }
    }
}
