//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUpVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var birthDayTextField: DezappTextField!
    @IBOutlet weak var emailTextField: DezappTextField!
    @IBOutlet weak var passwordTextField: DezappTextField!
    @IBOutlet weak var nameTextField: DezappTextField!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //signForNotifications()
        
        setTextFields()
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    //MARK: Private
    private func setTextFields(){
        nameTextField.returnKeyType = .next
        birthDayTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        emailTextField.returnKeyType = .done
    }
    
    private func signForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            birthDayTextField.becomeFirstResponder()
        case birthDayTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
