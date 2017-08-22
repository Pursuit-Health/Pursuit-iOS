//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by Igor on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var birthDayTextField    : DezappTextField!
    @IBOutlet weak var emailTextField       : DezappTextField!
    @IBOutlet weak var passwordTextField    : DezappTextField!
    @IBOutlet weak var nameTextField        : DezappTextField!

    //MARK: Variables
    
    var textFieldsArray: [DezappTextField] {
        return [self.nameTextField, self.birthDayTextField, self.passwordTextField, self.emailTextField]
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SignUpVC {
    func signUp(){
        
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        makeTextFieldsFirstResponder(textFieldsArray, textField)
        
        return true
    }
}

