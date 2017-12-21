//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SignInVCDelegate: class {
    func loginButtonPressed(on controller: SignInVC, with user: User, username: String, password: String)
    func forgotPasswordButtonPressed(on controller: SignInVC)
}

class SignInVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTeaxtField      : AnimatedTextField!
    @IBOutlet weak var passwordTextField    : AnimatedTextField!
    
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
}

extension SignInVC {
     func makeSignIn() {
        let email = emailTeaxtField.text ?? ""
        let password = passwordTextField.text ?? ""
        user.email      = email
        user.password   = password
        self.delegate?.loginButtonPressed(on: self, with: self.user, username: email, password: password)
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
//MARK: UITextFieldDelegate
extension SignInVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
}
