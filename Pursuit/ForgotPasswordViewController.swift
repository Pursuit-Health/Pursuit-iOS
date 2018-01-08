//
//  ForgotPasswordViewController.swift
//  Pursuit
//
//  Created by ігор on 8/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ForgotPasswordVCDelegate: class {
    func dissmissForgotPasswordVC()
}

class ForgotPasswordVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.attributedPlaceholder =  NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
    }
    
    //MARK: Variables
    
    weak var forgotPasswordVCDelegate: ForgotPasswordVCDelegate?
    
    //MARK: IBActions
    
    @IBAction func submitEmailButtonPressed(_ sender: Any) {
        submitEmail()
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //forgotPasswordVCDelegate?.dissmissForgotPasswordVC()
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setAppearence()
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        setUpStatusBarView()
    }
    
    fileprivate func setUpStatusBarView() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            for view in window.subviews {
                if view is TopStatusBarView {
                    view.removeFromSuperview()
                }
            }
            app.setUpStatusBarAppearence()
        }
    }
    
    private func submitEmail(){
        guard RegexExpression.validateEmail(string: emailTextField.text ?? "") else { invalidEmailAlert(); return}
        
        sendEmaiForNewPassword()
    }
    
    private func invalidEmailAlert(){
        let alert = UIAlertController(title: "Invalid Email", message: "Please check it and try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ForgotPasswordVC {
    func sendEmaiForNewPassword() {
        forgotPasswordRequest { error in
            if let error = error {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                self.navigationController?.popViewController(animated: true)
              //self.forgotPasswordVCDelegate?.dissmissForgotPasswordVC()
            }
        }
    }
    
    private func forgotPasswordRequest(completion: @escaping (_ error: ErrorProtocol?) -> Void){
        User.forgotPassword(email: emailTextField.text!) { success in
            completion(success)
        }
    }
}
