//
//  UILabel.swift
//  Pursuit
//
//  Created by ігор on 9/1/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

extension UILabel {
    func configureAppearence(isSelected: Bool, minFontSize: CGFloat, maxFontSize: CGFloat) {
        let font = UIFont.systemFont(ofSize: isSelected ? minFontSize : maxFontSize)
        
        let height = self.text?.height(withConstrainedWidth: 1000, font: font) ?? 0
        let width = self.text?.width(withConstraintedHeight: height, font: font) ?? 0
        if minimumScaleFactor != 0.1 {
            self.numberOfLines = 1
            self.minimumScaleFactor = 0.1
            self.adjustsFontSizeToFitWidth = true
        }
        
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
