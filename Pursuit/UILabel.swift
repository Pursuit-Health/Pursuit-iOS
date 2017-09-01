//
//  UILabel.swift
//  Pursuit
//
//  Created by ігор on 9/1/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UILabel {
    func configureAppearence(isSelected: Bool) {
        self.textColor = isSelected ? UIColor.white : UIColor.init(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
       // self.font = self.font.withSize(isSelected ? 8.0 : 17.0)
        UIView.animate(withDuration: 0.8, animations: {() -> Void in
           self.font = UIFont.boldSystemFont(ofSize: isSelected ? 10.0 : 17.0)
        })
    }
}
