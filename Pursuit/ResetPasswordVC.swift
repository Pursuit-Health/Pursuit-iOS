//
//  ResetPasswordVC.swift
//  Pursuit
//
//  Created by IgorMakara on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
//IGOR: Check
class ResetPasswordVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    //MARK: Variables
    
    static var hashString: String = ""
    
    //MARK: IBActions
    
    @IBAction func closeBarButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPasswordButtonPressed(_ sender: Any) {
        checkEqualityOfPasswords() ? submit() : presentDialog(title: "Error", errorString: "Different paswords entered in fields. Please try again.")
        setPassword()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = false
    }
    
    private func checkEqualityOfPasswords() -> Bool {
        return (newPasswordTextField.text == oldPasswordTextField.text)
    }
}

private extension ResetPasswordVC {
    
    func setPassword() {
        setPassword { success in
            if success {
                
            }
        }
    }
    
    private func setPassword(completion: @escaping (_ success: Bool) -> Void) {
        User.setPassword(password: newPasswordTextField.text ?? "", hash: ResetPasswordVC.hashString) { success in
            completion(success)
        }
    }
    
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
