//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol SignInVCDelegate: class {
    func lofinSuccessfull(on controller: SignInVC)
}

class SignInVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailLabel           : UILabel!
    @IBOutlet weak var passwordLabel        : UILabel!
    
    @IBOutlet weak var emailTeaxtField      : AnimatedTextField!
    @IBOutlet weak var passwordTextField    : AnimatedTextField!
    
    @IBOutlet var bottomEmailConstraint     : NSLayoutConstraint!
    @IBOutlet var bottomPasswordConstraint  : NSLayoutConstraint!
    
    //MARK: Variables
    
    weak var delegate: SignInVCDelegate?
    
    var textFieldsArray: [AnimatedTextField] {
        return [self.emailTeaxtField, self.passwordTextField]
    }
    
    var constraintsDictionary: [AnimatedTextField : NSLayoutConstraint] {
        return [emailTeaxtField:bottomEmailConstraint, passwordTextField:bottomPasswordConstraint]
    }
    
    var labelsDictionary : [AnimatedTextField : UILabel] {
        return [emailTeaxtField:emailLabel, passwordTextField:passwordLabel]
    }
    
    var loginData = User.PersonalData()
    
    var metaData = User.MetaData()
    
    var user: User?
    
    //MARK: IBActions
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        setParametersforRequest()
        makeSignIn()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        showForgotPasswordVC()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Private
    
    private func setParametersforRequest() {
//        loginData.email       = emailTeaxtField.text
//        loginData.password    =  passwordTextField
        loginData.email = "igor1994makara@gmail.com"
        loginData.password =  "123456789"
    }
    
    private func showForgotPasswordVC() {
        guard let forgotPVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController (withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC else { return }
        
        placeControllerToSuperView(forgotPVC)
    }
    
    private func placeControllerToSuperView(_ forgotPVC: ForgotPasswordVC) {
        
        addChildViewController(forgotPVC)
        let view = forgotPVC.view
        view?.tag = 123
        self.view.addSubview(view!)
        self.view.addConstraints(UIView.place(forgotPVC.view, onOtherView: self.view))
        
        forgotPVC.forgotPasswordVCDelegate = self
        
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
        User.login(loginData: loginData, completion: { userData, error in
            if let data = userData {
                completion(true)
                self.delegate?.lofinSuccessfull(on: self)
                
            }else {
                completion(false)
            }
        })
    }
}

extension SignInVC: ForgotPasswordVCDelegate {
    func dissmissForgotPasswordVC() {
        guard let viewWithTag = self.view.viewWithTag(123) else {return }
            viewWithTag.removeFromSuperview()
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
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {

    }
}
