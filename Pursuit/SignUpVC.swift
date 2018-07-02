//
//  SignUpVcViewController.swift
//  Pursuit
//
//  Created by Igor on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SHTextFieldBlocks

//IGOR: Check

protocol SignUpVCDelegate: class {
    func showSelectTrainerVC(on controller: SignUpVC)
    func signUpButtonPressed(on controller: SignUpVC, with user: User)
    func termsButtonPressed(on controller: SignUpVC)
}
class SignUpVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var userTypeSwitch: UISwitch!
    @IBOutlet weak var signUpTableView: UITableView! {
        didSet {
            self.signUpTableView.rowHeight          = UITableViewAutomaticDimension
            self.signUpTableView.estimatedRowHeight = 100
        }
    }
    
    //MARK: Variables
    
    weak var delegate: SignUpVCDelegate?
    var client      = Client()
    var trainer     = Trainer()
    
    var user: User? {
        didSet {
            let isTrainer = self.user is Trainer
            //TODO: move next three lines to separate method
            self.cellsInfo.remove(at: 0)
            self.cellsInfo.insert(.question(delegate: self, isTrainer: isTrainer), at: 0)
            
            let indexPath = IndexPath(row:1, section:0)
            //TODO: Also move to another method
            if let _ = self.signUpTableView.cellForRow(at: indexPath) as? ChooseTrainerCell {
                if isTrainer {
                    deleteTrainerRow()
                }
            } else {
                if !isTrainer {
                    insertTrainerRow()
                }
            }
        }
    }
    
    var trainerData = Trainer() {
        didSet {
            deleteTrainerRow()
            //TODO: make method with trainer parameter
            insertTrainerRow()
            self.client.id = trainerData.id
        }
    }
    
    lazy var cellsInfo: [CellType] = [.question(delegate: self, isTrainer: true), .name(delegate: self), .email(delegate: self), .password(delegate: self), .code(delegate: self), .birthday(delegate: self), .signup(delegate: self)]
    
    //MARK: Nested
    
    enum CellType {
        case name(delegate: UITextFieldDelegate)
        case email(delegate: UITextFieldDelegate)
        case password(delegate: UITextFieldDelegate)
        case code(delegate: UITextFieldDelegate)
        case birthday(delegate: UITextFieldDelegate)
        case question(delegate: QuestionCellDelegate, isTrainer: Bool)
        case selectTrainer(trainerName: String?)
        case signup(delegate: SignUpButtonCellDelegate)
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .name:
                return SignUpDataCell.self
            case .email:
                return SignUpDataCell.self
            case .password:
                return SignUpDataCell.self
            case .birthday:
                return SignUpDataCell.self
            case .question:
                return QuestionCell.self
            case .selectTrainer:
                return ChooseTrainerCell.self
            case .signup:
                return SignUpButtonCell.self
            case .code:
                return SignUpDataCell.self
            }
        }
        
        typealias TextFieldComletion = (_ text: String) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .name(let delegate):
                if let castedCell = cell as? SignUpDataCell {
                    fillNameCell(cell: castedCell, delegate: delegate, completion: { text in
                        completion(text)
                    })
                }
            case .email(let delegate):
                if let castedCell = cell as? SignUpDataCell {
                    fillEmailCell(cell: castedCell, delegate: delegate, completion: { text in
                        completion(text)
                    })
                }
            case .password(let delegate):
                if let castedCell = cell as? SignUpDataCell {
                    fillPasswordCell(cell: castedCell, delegate: delegate, completion: { text in
                        completion(text)
                    })
                }
            case .code(let delegate):
                if let castedCell = cell as? SignUpDataCell {
                    fillCodeCell(cell: castedCell, delegate: delegate, complation: { text in
                        completion(text)
                    })
                }
            case .birthday(let delegate):
                if let castedCell = cell as? SignUpDataCell {
                    fillBirthdayCell(cell: castedCell, delegate: delegate, completion: { text in
                        completion(text)
                    })
                }
            case .question(let delegate, let isTrainer):
                if let castedCell = cell as? QuestionCell {
                    fill(cell: castedCell, delegate: delegate, isTrainer: isTrainer)
                }
            case .selectTrainer(let trainerName):
                if let castedCell = cell as? ChooseTrainerCell {
                    
                    fill(cell: castedCell, trainerName: trainerName)
                }
                
            case .signup(let delegate):
                if let castedCell = cell as? SignUpButtonCell {
                    fill(cell: castedCell, delegate: delegate)
                }
            }
        }
        
        private func fillNameCell(cell: SignUpDataCell, delegate: UITextFieldDelegate, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Name"
            cell.userDataTextField.delegate = delegate
            cell.userDataTextField.tag = 0
            //TODO: this prt duplicates
            if cell.userDataTextField.text != "" {
                let multiplier = cell.userDataTextField.minFontSize / cell.userDataTextField.maxFontSize
                cell.userDataTextField.animatelabelfontQuick(from: 1, to: multiplier)
            }
            cell.cellImageview.image            = UIImage(named: "ic_username")
            cell.userDataTextField.keyboardType = .default
            cell.userDataTextField.returnKeyType = .next
            cell.userDataTextField.bbb_reactFromCodeChange = false
            cell.userDataTextField.isSecureTextEntry    = false
            cell.userDataTextField.bbb_changedBlock = { (textfield) in
                if let text = textfield.text {
                    completion(text)
                }
            }
        }
        
        private func fillEmailCell(cell: SignUpDataCell, delegate: UITextFieldDelegate, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Email"
            cell.userDataTextField.delegate = delegate
            cell.userDataTextField.tag = 1
            if cell.userDataTextField.text != "" {
                let multiplier = cell.userDataTextField.minFontSize / cell.userDataTextField.maxFontSize
                cell.userDataTextField.animatelabelfontQuick(from: 1, to: multiplier)
            }
            cell.userDataTextField.keyboardType = .emailAddress
            cell.userDataTextField.returnKeyType = .next
            cell.userDataTextField.bbb_reactFromCodeChange = false
            cell.userDataTextField.isSecureTextEntry    = false
            cell.cellImageview.image            = UIImage(named: "email")
            cell.userDataTextField.bbb_changedBlock = { (textfield) in
                if let text = textfield.text {
                    completion(text)
                }
            }
        }
        
        private func fillPasswordCell(cell: SignUpDataCell, delegate: UITextFieldDelegate, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Password"
            cell.userDataTextField.delegate = delegate
            cell.userDataTextField.tag = 2
            if cell.userDataTextField.text != "" {
                let multiplier = cell.userDataTextField.minFontSize / cell.userDataTextField.maxFontSize
                cell.userDataTextField.animatelabelfontQuick(from: 1, to: multiplier)
            }
            cell.userDataTextField.keyboardType = .default
            cell.userDataTextField.returnKeyType = .next
            cell.userDataTextField.bbb_reactFromCodeChange = false
            cell.userDataTextField.isSecureTextEntry    = true
            cell.cellImageview.image                    = UIImage(named: "ic_password")
            cell.userDataTextField.bbb_changedBlock = { (textfield) in
                if let text = textfield.text {
                    completion(text)
                }
            }
        }
        
        private func fillCodeCell(cell: SignUpDataCell, delegate: UITextFieldDelegate, complation: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Code"
            cell.userDataTextField.delegate = delegate
            cell.userDataTextField.tag = 3
            if cell.userDataTextField.text != "" {
                let multiplier = cell.userDataTextField.minFontSize / cell.userDataTextField.maxFontSize
                cell.userDataTextField.animatelabelfontQuick(from: 1, to: multiplier)
            }
            cell.cellImageview.image            = UIImage(named: "code")
            cell.userDataTextField.keyboardType = .default
            cell.userDataTextField.returnKeyType = .next
            //TODO: Reimplement
            cell.userDataTextField.bbb_reactFromCodeChange = true
            cell.userDataTextField.isSecureTextEntry    = false
           // cell.userDataTextField.keyboardType         = .numberPad
            cell.userDataTextField.bbb_changedBlock = { (textfield) in
                if let text = textfield.text {
                    complation(text)
                }
            }
        }
        
        private func fillBirthdayCell(cell: SignUpDataCell, delegate: UITextFieldDelegate, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Birthday"
            cell.userDataTextField.delegate = delegate
            cell.userDataTextField.tag = 4
            if cell.userDataTextField.text != "" {
                let multiplier = cell.userDataTextField.minFontSize / cell.userDataTextField.maxFontSize
                cell.userDataTextField.animatelabelfontQuick(from: 1, to: multiplier)
            }
            cell.cellImageview.image            = UIImage(named: "gift")
            
            //TODO: Reimplement
            cell.userDataTextField.keyboardType = .default
            cell.userDataTextField.bbb_reactFromCodeChange = true
            cell.userDataTextField.isSecureTextEntry    = false
            cell.userDataTextField.inputView = cell.datePicker()
            cell.userDataTextField.bbb_changedBlock = { (textfield) in
                if let text = textfield.text {
                    completion(text)
                }
            }
        }
        
        private func fill(cell: QuestionCell, delegate: QuestionCellDelegate, isTrainer: Bool) {
            cell.delegate = delegate
            if isTrainer {
                cell.selectTrainer()
            } else {
                cell.selectClient()
            }
        }
        
        private func fill(cell: ChooseTrainerCell, trainerName: String?) {
            cell.trainerNameLabel.text = trainerName ?? "Select Trainer"
            cell.iconImageView.image   = UIImage(named: "dots")
        }
        
        private func fill(cell: SignUpButtonCell, delegate: SignUpButtonCellDelegate) {
            cell.delegate = delegate
        }
    }
    
    //MARK: Private
    
    fileprivate func deleteTrainerRow() {
        let indexPath = IndexPath(row:1, section:0)
        self.cellsInfo.remove(at: 1)
        self.signUpTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //TODO: parameter trsineer
    fileprivate func insertTrainerRow() {
        let indexPath = IndexPath(row:1, section:0)
        self.cellsInfo.insert(.selectTrainer(trainerName: self.trainerData.name), at: 1)
        self.signUpTableView.insertRows(at: [indexPath], with: .fade)
    }
    
    fileprivate func isValidFieldsFor(_ user: User) -> Bool {
        if user.name?.isEmpty ?? true || user.email?.isEmpty ?? true || user.code?.isEmpty ?? true || user.birthday?.isEmpty ?? true || user.birthday?.isEmpty ?? true {
            return false
        }
        return true
    }
    
    fileprivate func showAlert(_ title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func signUp() {
        if let user = self.user {
            if isValidFieldsFor(user) {
                self.delegate?.signUpButtonPressed(on: self, with: user)
            }else {
                showAlert(nil, message: "Please fill the all fields.")
            }
        }
    }
}

extension SignUpVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellsInfo[indexPath.row]
        
        guard let cell = tableView.gc_dequeueReusableCell(type: cellType.cellType) else { return UITableViewCell() }
        //TODO: Reimplement
        cellType.fillCell(cell: cell, completion: { text in
            
            //TODO: Move to seprate method
            switch cellType {
            case .name:
                self.client.name        = text
                self.trainer.name       = text
            case .password:
                
                self.client.password    = text
                self.trainer.password   = text
            case .email:
                
                self.client.email       = text
                self.trainer.email      = text
            case .code:
                self.client.code    = text
                self.trainer.code   = text
            case .birthday:
                
                //TODO: Move date formatter to constants
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd,yyyy"
                
                if let date = dateFormatter.date(from: text) {
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let birthday = dateFormatter.string(from: date)
                    
                    self.client.birthday    = birthday
                    self.trainer.birthday   = birthday
                }
                
            default:
                return
            }
        })
        return cell
    }
}

extension SignUpVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? ChooseTrainerCell {
            delegate?.showSelectTrainerVC(on: self)
        }
    }
}

extension SignUpVC: SignUpButtonCellDelegate {
    
    func termsButtonPressed(on cell: SignUpButtonCell) {
        self.delegate?.termsButtonPressed(on: self)
    }
    
    func signUpButtonPressed(on cell: SignUpButtonCell) {
        signUp()
    }
}

extension SignUpVC: QuestionCellDelegate {
    func isTrainer(_ isTrainer: Bool, on cell: QuestionCell) {
        if isTrainer {
            self.user = self.trainer
        } else {
            self.user = self.client
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        textField.resignFirstResponder()
        let nextField = signUpTableView.viewWithTag(tag + 1)
        nextField?.becomeFirstResponder()

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 4 {
            signUp()
        }
    }
}

