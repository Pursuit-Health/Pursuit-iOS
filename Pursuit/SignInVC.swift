//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SignInVCDelegate: class {
    func loginButtonPressed(on controller: SignInVC, with user: User)
    func forgotPasswordButtonPressed(on controller: SignInVC)
}

class SignInVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTeaxtField      : AnimatedTextField! {
        didSet {
            emailTeaxtField.returnKeyType = .next
        }
    }
    @IBOutlet weak var passwordTextField    : AnimatedTextField! {
        didSet {
            passwordTextField.returnKeyType = .done
        }
    }
    
    //MARK: Variables
    
    weak var delegate: SignInVCDelegate?
    
    var user = User()
    
    //MARK: IBActions
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        makeSignIn()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        delegate?.forgotPasswordButtonPressed(on: self)
    }
    
    fileprivate func showAlert(_ title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func isValidFields(_ user: User) -> Bool {
        let email     = user.email ?? ""
        let password  = user.password ?? ""
        if email.isEmpty || password.isEmpty {
            return false
        }
        return true
    }
}

extension SignInVC {
     func makeSignIn() {
        if isValidFields(self.user) {
            self.delegate?.loginButtonPressed(on: self, with: self.user)
        }else {
            showAlert("Error", message: "Please fill the all fields.")
        }
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
//MARK: UITextFieldDelegate
extension SignInVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTeaxtField {
            emailTeaxtField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            makeSignIn()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == emailTeaxtField {
            user.email      = emailTeaxtField.text ?? ""
        }else if textField == passwordTextField {
            user.password   = passwordTextField.text ?? ""
        }
    }
}
