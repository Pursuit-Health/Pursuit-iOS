//
//  ResetPasswordVC.swift
//  Pursuit
//
//  Created by IgorMakara on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    //MARK: IBActions
    
    @IBAction func submitPasswordButtonPressed(_ sender: Any) {
        checkEqualityOfPasswords() ? submit() : presentDialog(title: "Error", errorString: "Different paswords entered in fields. Please try again.")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
    }
    
    private func checkEqualityOfPasswords() -> Bool {
        return (newPasswordTextField.text == oldPasswordTextField.text)
    }
}

extension ResetPasswordVC {
     func submit() {
        submitPassword { success in
            if success {
                
            }
        }
    }
    private func submitPassword(completion: @escaping (_ success: Bool)-> Void) {
        User.changePassword(password: newPasswordTextField.text!) { success in
            completion(success)
        }
    }
}
