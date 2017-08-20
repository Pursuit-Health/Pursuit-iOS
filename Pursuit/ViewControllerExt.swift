//
//  ViewControllerExt.swift
//  CoachX
//
//  Created by Kent Guerriero on 1/19/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import Foundation
import UIKit

//TODO: separate extensions int odifferent file

extension UIViewController {
    func presentDialog(title : String, errorString : String ){
        let alert = UIAlertController(title: title, message: errorString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addReveal(){
        let revealButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        revealButton.setImage(UIImage(named: "hamburgerIcon"), for: .normal)
        revealButton.addTarget(self, action: #selector(UIViewController.showMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: revealButton)
    }
    
    func addBack(){
        let revealButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 18))
        revealButton.setImage(UIImage(named: "back"), for: .normal)
        revealButton.addTarget(self, action: #selector(UIViewController.backPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: revealButton)
    }
    
    func backPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func showMenu(){
        //        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func setupKeyboardListeners(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - NSNotification
    func keyboardWillShow(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.setKeyboardWillShowConstraint(height: frame.height)
        }) { (finished: Bool) -> Void in
            
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.setKeyboardWillHideConstraint()
        })
    }
    
    func setKeyboardWillHideConstraint(){
        
    }
    
    func setKeyboardWillShowConstraint(height : CGFloat){
        
    }
    
}
//TODO: reimplement due to comments
import ObjectiveC
extension UIViewController {
    
    private static var left_associated_key: UInt8   = 0
    
    @IBInspectable
    public var leftTitle: String? {
        set {
            objc_setAssociatedObject(self, &UIViewController.left_associated_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            addLeft(title: newValue ?? "")
        }
        
        get {
            return objc_getAssociatedObject(self, &UIViewController.left_associated_key) as? String
        }
    }
    
    func addLeft(title: String) {
        
        var items: [UIBarButtonItem] = []
        let rightItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        rightItem.customView = setUpTitleLabelApperence(title: title)
        let leftBarItems = self.navigationItem.leftBarButtonItems ?? []
        if leftBarItems.count == 0 {
            items.append(rightItem)
        }else {
            items = leftBarItems
            items.append(rightItem)
        }
        items = [leftBarItems, rightItem].flatMap{ $0 }
        self.navigationItem.leftBarButtonItems = items
        
    }
    
    func setUpTitleLabelApperence(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Book", size: 17.0)
        titleLabel.bounds = CGRect(x: 0, y: 0, width: 200, height: 40)
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    func updateLeftTitle(newTitle: String) {
        var items: [UIBarButtonItem] = []
        let barButtonItems = self.navigationItem.leftBarButtonItems ?? []
        items = barButtonItems
        
        if items.count == 0 {
            return
        }
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.customView = setUpTitleLabelApperence(title: newTitle)
        
        items.removeLast()
        items.append(item)
        
        self.navigationItem.leftBarButtonItems = items
        
    }

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

extension UIViewController {
    func makeTextFieldsFirstResponder(_ textFieldsArray: [DezappTextField],_ textField: UITextField) {
        for (index, value) in textFieldsArray.enumerated() {
            if value == textField {
                if index == textFieldsArray.endIndex - 1 {
                    textFieldsArray[index].resignFirstResponder()
                    return
                }
                textFieldsArray[index + 1].becomeFirstResponder()
            }
        }
    }
}
