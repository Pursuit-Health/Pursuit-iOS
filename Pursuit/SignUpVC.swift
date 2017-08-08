//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var birthDayTextField: DezappTextField!
    @IBOutlet weak var emailTextField: DezappTextField!
    @IBOutlet weak var passwordTextField: DezappTextField!
    @IBOutlet weak var nameTextField: DezappTextField!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
