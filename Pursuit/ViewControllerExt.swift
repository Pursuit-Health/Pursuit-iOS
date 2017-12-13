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
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg")
       // imageView.bounds = self.view.bounds
        //imageView.frame = self.view.frame
        imageView.contentMode = .scaleToFill
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.view.insertSubview(imageView, at: 0)

       let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)

       let bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        //NSLayoutConstraint.activate([leading, trailing, top, bottom])
        let equalWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let centerX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        view.addConstraints([equalWidth, top, bottom, centerX])
    }
    
    func addViewToBottom() {
        
        if #available(iOS 11, *) {
            UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        
        }
        
        
        let view = UIView()
        
        view.backgroundColor = .red//UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(view)
        
       // let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        //NSLayoutConstraint.activate([leading, trailing, top, bottom])
        let equalWidth = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 34)
        //view.addConstraint(height)
        //self.view.addConstraints([equalWidth, bottom, centerX, height])
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

