//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var signUpTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibs()
        
        signUpTableView.rowHeight = UITableViewAutomaticDimension
        signUpTableView.estimatedRowHeight = 400
    }
    func registerXibs(){
        signUpTableView.register(UINib(nibName: "SignUpCell", bundle: nil), forCellReuseIdentifier: "SignUpCell")
    }
    
}
extension SignUpVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpCell", for: indexPath) as! SignUpCell
        cell.selectionStyle = .none
        //        signUpEmail = cell.emailField
        //        signUpPassword = cell.passwordField
        //        signUpName = cell.nameField
        //
        //
        //        cell.emailField.tag = kEmailField
        //        cell.passwordField.tag = kPasswordField
        //        cell.nameField.tag = kNameField
        
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
    
    func setupSignUpCell(indexPath : IndexPath) -> UITableViewCell {
        let cell = signUpTableView.dequeueReusableCell(withIdentifier: "SignUpCell", for: indexPath) as! SignUpCell
        cell.selectionStyle = .none
        //        signUpEmail = cell.emailField
        //        signUpPassword = cell.passwordField
        //        signUpName = cell.nameField
        //
        //
        //        cell.emailField.tag = kEmailField
        //        cell.passwordField.tag = kPasswordField
        //        cell.nameField.tag = kNameField
        
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
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 400
    //    }
}

extension SignUpVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
