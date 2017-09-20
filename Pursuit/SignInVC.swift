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
    
    var user: User?
    
    var loginData = User()
    
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
        loginData.email = "igor1994ma@gmail.com"
        loginData.password = "123456789"
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
        makeSignIn { error in
            if error == nil {
                //go to login
            }
        }
    }
    
    //TODO: Wehy we always send back sing completion?
    func makeSignIn(completion: @escaping (_ error: ErrorProtocol?)-> Void) {
        User.login(loginData: loginData, completion: { _, error in
            if error == nil {
                self.delegate?.lofinSuccessfull(on: self)
            }
            completion(error)
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
