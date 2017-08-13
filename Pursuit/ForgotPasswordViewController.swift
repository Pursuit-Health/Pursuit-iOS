//
//  ForgotPasswordViewController.swift
//  Pursuit
//
//  Created by ігор on 8/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    //MARK: Variables
    
    //MARK: IBActions

    @IBAction func submitEmailButtonPressed(_ sender: Any) {
        
        submitEmail()
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func submitEmail(){
        guard validateEmail() else { invalidEmailAlert(); return}
        
        //API call forgot password
    }
    
    private func invalidEmailAlert(){
        let alert = UIAlertController(title: "Invalid Email", message: "Please check it and try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: -   EmailValidation

private extension ForgotPasswordVC {
    func validateEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: emailTextField.text ?? "")
    }
}
