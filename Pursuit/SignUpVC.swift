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
    
    var user = User().signUpData
    
    @IBAction func signUpButtonPresseed(_ sender: Any) {
        signUp()
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user?.userAccount      = "client"
        user?.email            = "email"
        user?.password         = "password"
        user?.gender           = "gender"
        user?.birthday         = "birthday"
    }
}

private extension SignUpVC {
    func signUp(){
        makeSignUp { success in
            if success {
                //go to login
            }
        }
        
    }
    
    func makeSignUp(completion: @escaping (_ success: Bool)-> Void) {
        print(user?.userAccount)
        
        
        User.signUp(signUpInfo: (user)!, completion: { signUpInfo, error in
            if let success = signUpInfo {
                print(success)
                completion(true)
            }else {
                completion(false)
            }
        })
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        makeTextFieldsFirstResponder(textFieldsArray, textField)
        
        return true
    }
}

