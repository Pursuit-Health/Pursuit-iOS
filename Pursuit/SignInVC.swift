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
    
    @IBOutlet weak var emailLabel           : UILabel!
    @IBOutlet weak var passwordLabel        : UILabel!
    
    @IBOutlet weak var emailTeaxtField      : DezappTextField!
    @IBOutlet weak var passwordTextField    : DezappTextField!
    
    @IBOutlet var bottomEmailConstraint     : NSLayoutConstraint!
    @IBOutlet var bottomPasswordConstraint  : NSLayoutConstraint!
    
    //MARK: Variables
    
    var changeConstraint: Bool = false {
        didSet{
            
        }
    }
    
    var textFieldsArray: [DezappTextField] {
        return [self.emailTeaxtField, self.passwordTextField]
    }
    
    var constraintsDictionary: [DezappTextField : NSLayoutConstraint] {
        return [emailTeaxtField:bottomEmailConstraint, passwordTextField:bottomPasswordConstraint]
    }
    
    var labelsDictionary : [DezappTextField : UILabel] {
        return [emailTeaxtField:emailLabel, passwordTextField:passwordLabel]
    }
    
    var loginData = User.PersonalData()
    //MARK: IBActions
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        makeSignIn()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        showForgotPasswordVC()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginData.email = "igor1994makara@gmail.com"
        loginData.password =  "123456789"
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


private extension SignInVC {
    func makeSignIn(){
        makeSignIn { success in
            if success {
                //go to login
            }
        }
    }
    
    func makeSignIn(completion: @escaping (_ success: Bool)-> Void) {
        User.login(loginData: loginData, completion: { signUpInfo, error in
            if let success = signUpInfo {
                
                completion(true)
            }else {
                completion(false)
            }
       })
    }
}

//TODO: think after MVP together beter organizatin. Do not fix it yet.
//MARK: UITextFieldDelegate
extension SignInVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        makeTextFieldsFirstResponder(textFieldsArray, textField)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.animateText(constraint: constraintsDictionary[(textField as? DezappTextField)!]!, isSelected: true)
        labelsDictionary[(textField as? DezappTextField)!]?.configureAppearence(isSelected: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.animateText(constraint: constraintsDictionary[(textField as? DezappTextField)!]!, isSelected: false)
        labelsDictionary[(textField as? DezappTextField)!]?.configureAppearence(isSelected: false)
    }
}
