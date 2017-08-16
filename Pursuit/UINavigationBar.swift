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
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
