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
    
    @IBOutlet weak var oldPasswordTextField: UITextField! {
        didSet {
            self.oldPasswordTextField.attributedPlaceholder = createPlaceHolder(text: "New Password")
        }
    }
    
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            self.newPasswordTextField.attributedPlaceholder = createPlaceHolder(text: "Confirm New Password")
        }
    }
    
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
        
        setUpStatusBarView()
        //navigationController?.navigationBar.isHidden = false
    }
    
    func createPlaceHolder(text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes:  [NSAttributedStringKey.font : UIFont(name: "Avenir-Book", size: 14.0)!, NSAttributedStringKey.foregroundColor : UIColor.white])
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
    
    private func checkEqualityOfPasswords() -> Bool {
        return (newPasswordTextField.text == oldPasswordTextField.text)
    }
}

private extension ResetPasswordVC {
    
    func setPassword() {
        setPassword { error in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
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
