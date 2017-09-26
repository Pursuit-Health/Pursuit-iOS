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
        checkEqualityOfPasswords() ? setPassword() : presentDialog(title: "Error", errorString: "Different paswords entered in fields. Please try again.")
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
        setPassword { error in
            if error == nil {
                 self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setPassword(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        User.setPassword(password: newPasswordTextField.text ?? "", hash: ResetPasswordVC.hashString) { success in
            completion(success)
        }
    }
    
     func submit() {
        submitPassword { error in
            if error == nil {
                
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func submitPassword(completion: @escaping (_ error: ErrorProtocol?)-> Void) {
        User.changePassword(password: newPasswordTextField.text!) { success in
            completion(success)
        }
    }
}
