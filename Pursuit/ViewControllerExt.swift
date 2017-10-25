//
//  ViewControllerExt.swift
//  CoachX
//
//  Created by Kent Guerriero on 1/19/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentDialog(title : String, errorString : String ){
        let alert = UIAlertController(title: title, message: errorString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

import ObjectiveC
extension UIViewController {
     func setUpBackgroundImage() {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.bounds = self.view.bounds
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleToFill
        self.view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
         self.view.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.1)
    }
}


import ObjectiveC
extension UIViewController {
    
    private static var left_associated_key: UInt8   = 0
    
    @IBInspectable
    public var leftTitle: String? {
        set {
            self.navigationItem.leftTitle = newValue
        }
        
        get {
            return self.navigationItem.leftTitle
        }
    }
}

