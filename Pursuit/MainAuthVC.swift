//
//  LoginVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import KVNProgress

protocol MainAuthVCDelegate: class {
   func userDidPressedSignUpButton()
    func userDidPressedSignInButton()
}

class MainAuthVC: UIViewController {
    
    var delegate: MainAuthVCDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var signUpSelectionView: UIView!
    @IBOutlet var signInSelectionView: UIView!
    
    @IBOutlet var signUpButton: DezappButton!
    @IBOutlet var signInButton: DezappButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    var authState : AuthState = .SignIn
    let kSignUp = "SIGN UP"
    let kSignIn = "SIGN IN"
    
    let kEmailField = 1
    let kPasswordField = 2
    let kNameField = 3
    let kResetPasswordEmail = 4
    
    var signInModel : LoginModel = LoginModel()
    var signUpModel : LoginModel = LoginModel()
    var resetPasswordModel : LoginModel = LoginModel()
    
    var signInEmail : UITextField?
    var signInPassword : UITextField?
    
    var signUpEmail : UITextField?
    var signUpPassword : UITextField?
    var signUpName : UITextField?
    
    var pageVC: PageViewController? {
        didSet {
            pageVC?.delegateForNotifyMain = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTableView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainAuthVC.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        setUpPageViewControllerForShow()
        
        // signUpSelectionView.isHidden = true
        authState = .SignIn
   
    }
    
    func setUpPageViewControllerForShow(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "PageVC") as! PageViewController
        controller.mainAuth = self
        addChildViewController(controller)
        controller.view.frame = CGRect(x: 0, y: self.view.frame.size.height*0.41, width: self.view.frame.size.width, height: self.view.frame.size.height*0.6)
        view.addSubview((controller.view)!)
        controller.didMove(toParentViewController: self)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        delegate?.userDidPressedSignUpButton()
        
        if authState == .SignIn || authState == .ForgotPassword {
            signInSelectionView.isHidden = true
            signUpSelectionView.isHidden = false
            authState = .SignUp
            let path = IndexPath(row: 0, section: 0)
            //tableView.reloadRows(at: [path], with: .left)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        delegate?.userDidPressedSignInButton()
        
        if authState == .SignUp || authState == .ForgotPassword {
            signInSelectionView.isHidden = false
            signUpSelectionView.isHidden = true
            authState = .SignIn
            let path = IndexPath(row: 0, section: 0)
            //tableView.reloadRows(at: [path], with: .right)
        }
    }
    
    func forgotPasswordSelected(){
        authState = .ForgotPassword
        let path = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [path], with: .top)
        signInSelectionView.isHidden = true
        signUpSelectionView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardListeners()
    }
    
    override func setKeyboardWillShowConstraint(height: CGFloat) {
       // self.bottomConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func setKeyboardWillHideConstraint() {
       // self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SignUpCell", bundle: nil), forCellReuseIdentifier: "SignUpCell")
        tableView.register(UINib(nibName: "SignInCell", bundle: nil), forCellReuseIdentifier: "SignInCell")
        tableView.register(UINib(nibName: "ForgotPasswordCell", bundle: nil), forCellReuseIdentifier: "ForgotPasswordCell")
        
        tableView.separatorStyle = .none
    }
    
    func signInPressed(){
        //        let sb = UIStoryboard(name: "TrainerMain", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "PursuitNVC")
        //        self.present(vc, animated: true, completion: nil)
        //        if validateSignIn() {
        //            KVNProgress.show(withStatus: "Signing in...")
        //            API.signIn(email: signInModel.email!, password: signInModel.password!, completion: { (user, error) in
        //                KVNProgress.dismiss()
        //                if error != nil {
        //                    self.presentDialog(title : "Error" , errorString: error!.localizedDescription)
        //                }else{
        //                    self.showMainNC()
        //                }
        //            })
        //        }
        
        self.showMainNC()
    }
    
    func signUpPressed(){
        //        if validateSignUp() {
        //            KVNProgress.show(withStatus: "Signing up...")
        //            API.createAccount(name: signUpModel.name!, email: signUpModel.email!, password: signUpModel.password!, completion: { (user, error) in
        //                if error != nil {
        //                    KVNProgress.dismiss()
        //                    self.presentDialog(title : "Error", errorString: error!.localizedDescription)
        //                }else{
        //                    KVNProgress.showSuccess()
        //                    self.showMainNC()
        //                }
        //            })
        //        }
    }
    
    func showMainNC(){
        let storyboard = UIStoryboard(name: "TrainerMain", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "navController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func validateSignUp() -> Bool {
        //        var isValid = true
        //        var errorString = ""
        //        if signUpModel.email == nil || signUpModel.email?.isValidEmail() == false {
        //            isValid = false
        //            errorString = "Please enter a valid email address"
        //        }
        //        else if signUpModel.password == nil || signUpModel.password?.isEmpty == true {
        //            isValid = false
        //            errorString = "Please enter a valid password"
        //        }
        //        else if signUpModel.name == nil || signUpModel.name?.isEmpty == true {
        //            isValid = false
        //            errorString = "Please enter a valid name"
        //        }
        //
        //        if isValid == false {
        //            presentDialog(title: "Error", errorString: errorString)
        //        }
        //
        //        return isValid
        return true
    }
    
    
    func validateSignIn() -> Bool {
        //        var isValid = true
        //        var errorString = ""
        //        if signInModel.email == nil || signInModel.email?.isValidEmail() == false {
        //            isValid = false
        //            errorString = "Please enter a valid email address"
        //        }
        //        else if signInModel.password == nil || signInModel.password?.isEmpty == true {
        //            isValid = false
        //            errorString = "Please enter a valid password"
        //        }
        //
        //        if isValid == false {
        //            presentDialog(title: "Error", errorString: errorString)
        //        }
        //
        //        return isValid
        return true
    }
    
    func validateResetPassword() -> Bool {
        //        var isValid = true
        //        var errorString = ""
        //        if resetPasswordModel.email == nil || resetPasswordModel.email?.isValidEmail() == false {
        //            isValid = false
        //            errorString = "Please enter a valid email address"
        //        }
        //        if isValid == false {
        //            presentDialog(title: "Error", errorString: errorString)
        //        }
        //        return isValid
        return true
    }
    
    func textFieldUpdated(textField : UITextField){
        //        let text = textField.text
        //        if authState == .SignIn {
        //            switch textField.tag {
        //                case kEmailField:
        //                    signInModel.email = text
        //                default:
        //                    signInModel.password = text
        //            }
        //        }else if authState == .SignUp{
        //            switch textField.tag {
        //                case kEmailField:
        //                    signUpModel.email = text
        //                case kNameField:
        //                    signUpModel.name = text
        //                default:
        //                    signUpModel.password = text
        //            }
        //        }else{ //Forgot password
        //            resetPasswordModel.email = text
        //        }
    }
    
    func resetPasswordPressed(){
        //        if validateResetPassword() {
        //            KVNProgress.show()
        //            API.resetPassword(email: resetPasswordModel.email!) { (error) in
        //                if error != nil {
        //                    self.presentDialog(title: "Error", errorString: error!.localizedDescription)
        //                }
        //                else{
        //                    KVNProgress.showSuccess(withStatus: "A password reset email was sent to the email address", completion: {
        //                        self.signInButtonPressed(NSObject())
        //                    })
        //                }
        //            }
        //        }
    }
    
}

extension MainAuthVC : UITableViewDelegate, UITableViewDataSource {
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if authState == .SignIn {
            return setupSignInCell(indexPath: indexPath)
        }
        else if authState == .SignUp{
            return setupSignUpCell(indexPath: indexPath)
        }else{
            return setupForgotPasswordCell()
        }
    }
    
    func setupForgotPasswordCell() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotPasswordCell") as! ForgotPasswordCell
        
        //        if let email = resetPasswordModel.email {
        //            cell.emailField.updateAttributedTextWithString(string: email)
        //        }
        cell.emailField.tag = kResetPasswordEmail
        cell.emailField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.submitButton.addTarget(self, action: #selector(MainAuthVC.resetPasswordPressed), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func setupSignInCell(indexPath : IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignInCell", for: indexPath) as! SignInCell
        cell.selectionStyle = .none
        signInEmail = cell.emailField
        signInPassword = cell.passwordField
        
        
        //        if let email = signInModel.email {
        //            cell.emailField.updateAttributedTextWithString(string: email)
        //        }
        //        if let pw = signInModel.password {
        //            cell.passwordField.updateAttributedTextWithString(string: pw)
        //        }
        
        cell.passwordField.returnKeyType = .done
        cell.emailField.returnKeyType = .next
        cell.emailField.delegate = self
        cell.passwordField.delegate = self
        
        cell.emailField.tag = kEmailField
        cell.passwordField.tag = kPasswordField
        cell.emailField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.passwordField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.forgotPasswordButton.addTarget(self, action: #selector(MainAuthVC.forgotPasswordSelected), for: .touchUpInside)
        cell.submitButton.addTarget(self, action: #selector(MainAuthVC.signInPressed), for: .touchUpInside)
        return cell
    }
    
    func setupSignUpCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpCell", for: indexPath) as! SignUpCell
        cell.selectionStyle = .none
        signUpEmail = cell.emailField
        signUpPassword = cell.passwordField
        signUpName = cell.nameField
        
        
        cell.emailField.tag = kEmailField
        cell.passwordField.tag = kPasswordField
        cell.nameField.tag = kNameField
        
        //        if let email = signUpModel.email {
        //            cell.emailField.updateAttributedTextWithString(string: email)
        //        }
        //        if let pw = signUpModel.password {
        //            cell.passwordField.updateAttributedTextWithString(string: pw)
        //        }
        //        if let name = signUpModel.name {
        //            cell.nameField.updateAttributedTextWithString(string: name)
        //        }
        
        cell.passwordField.returnKeyType = .done
        cell.emailField.returnKeyType = .next
        cell.nameField.returnKeyType = .next
        
        cell.nameField.delegate = self
        cell.passwordField.delegate = self
        cell.emailField.delegate = self
        
        cell.emailField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.passwordField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.nameField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        
        cell.submitButton.addTarget(self, action: #selector(MainAuthVC.signUpPressed), for: .touchUpInside)
        
        return cell
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}

extension MainAuthVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if authState == .SignIn {
            if textField.tag == kEmailField {
                signInPassword?.becomeFirstResponder()
            }else{
                dismissKeyboard()
                return true
            }
        }else{
            if textField.tag == kNameField {
                signUpEmail?.becomeFirstResponder()
            }
            else if textField.tag == kEmailField {
                signUpPassword?.becomeFirstResponder()
            }else{
                dismissKeyboard()
                return true
            }
        }
        return false
    }
}

enum AuthState {
    case SignIn
    case SignUp
    case ForgotPassword
}

extension MainAuthVC: PageViewControllerDelegate {
    func changeControllersInPageVC(index: Int) {
        

        view.layoutSubviews()
        DispatchQueue.main.async {
            //self.signInSelectionView.isHidden = true
        }
        
         //signInSelectionView.isHidden = false
        //signUpSelectionView.backgroundColor = .green
        switch index {
            
           
        case 0: break

            
        case 1: break

            
        default:
            break
        }
    }
}
