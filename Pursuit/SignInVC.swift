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
    
    //MARK: IBActions
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        showForgotPasswordVC()
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Private
    
    private func showForgotPasswordVC() {
        guard let forgotPVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController (withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC else { return }
        
        placeControllerToSuperView(forgotPVC)
    }
    
    private func placeControllerToSuperView(_ forgotPVC: ForgotPasswordVC) {
        addChildViewController(forgotPVC)
        
        self.view.addSubview(forgotPVC.view)
        self.view.addConstraints(UIView.place(forgotPVC.view, onOtherView: self.view))
        
        forgotPVC.didMove(toParentViewController: self)
    }
    
}


//TODO: Mayby think a better solution
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
