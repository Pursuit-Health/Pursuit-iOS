//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignInVC: UIViewController {
    
    //MARK: IBOutlets

    @IBOutlet weak var emailTeaxtField: DezappTextField!
    @IBOutlet weak var passwordTextField: DezappTextField!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK: UITextFieldDelegate
extension SignInVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTeaxtField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
