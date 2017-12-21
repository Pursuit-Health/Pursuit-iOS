//
//  UIView+CornerRadius.swift
//  Pursuit
//
//  Created by ігор on 12/20/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UIView {
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }
