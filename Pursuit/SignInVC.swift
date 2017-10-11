//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SignInVCDelegate: class {
    func lofinSuccessfull(on controller: SignInVC)
}

class SignInVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTeaxtField      : AnimatedTextField!
    @IBOutlet weak var passwordTextField    : AnimatedTextField!
    
    //MARK: Variables
    
    weak var delegate: SignInVCDelegate?
    
    var user: User?
    
    var loginData = User()
    
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
        
    }
    
    //MARK: Private
    
    private func setParametersforRequest() {
        
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
                //
                //                User.refreshToken(completion: { (error) in
                //                    if error == nil {
                //
                //                    }
                //                })
            }
        }
    }
    
    //TODO: Wehy we always send back sing completion?
    private func makeSignIn(completion: @escaping (_ error: ErrorProtocol?)-> Void) {
        User.login(email: emailTeaxtField.text ?? "", password: passwordTextField.text ?? "", completion: { _, error in
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
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
}
