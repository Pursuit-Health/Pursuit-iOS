//
//  SignInViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var signInTableView: UITableView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibs()
        
        configureTableView()
        
        self.preferredContentSize  = CGSize(width:(self.view.frame.size.width / 100) * 65,height: (self.view.frame.size.height / 100) * 65);
    }
    
    //MARK: Private
   private func registerXibs(){
        signInTableView.register(UINib(nibName: "SignInCell", bundle: nil), forCellReuseIdentifier: "SignInCell")
    }
    
   private func configureTableView(){
        signInTableView.rowHeight = UITableViewAutomaticDimension
        signInTableView.estimatedRowHeight = 400
    }
}

//MARK: UITableViewDataSource
extension SignInVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignInCell", for: indexPath) as! SignInCell
        cell.selectionStyle = .none
        //        signInEmail = cell.emailField
        //        signInPassword = cell.passwordField
        
        
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
        
        //        cell.emailField.tag = kEmailField
        //        cell.passwordField.tag = kPasswordField
        cell.emailField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.passwordField.addTarget(self, action: #selector(MainAuthVC.textFieldUpdated(textField:)), for: .editingChanged)
        cell.forgotPasswordButton.addTarget(self, action: #selector(MainAuthVC.forgotPasswordSelected), for: .touchUpInside)
        cell.submitButton.addTarget(self, action: #selector(MainAuthVC.signInPressed), for: .touchUpInside)
        return cell    }
}

extension SignInVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
