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
