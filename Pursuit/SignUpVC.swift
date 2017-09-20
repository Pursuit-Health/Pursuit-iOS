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
    
    var personalData = User.PersonalData()
    
    var clientPersonalData = Client()
    
    var trainerPersonalData: Trainer?
    
    var trainer = Trainer() {
        didSet {
            clientPersonalData.trainerId = self.trainer.trainerId
            
            deleteTrainerRow()
            
            insertTrainerRow()
        }
    }
    
    lazy var cellsInfo: [CellType] = [.question(delegate: self), .name, .email, .password, .birthday, .signup(delegate: self)]
    
    //MARK: Nested
    
    enum CellType {
        case name
        case email
        case password
        case birthday
        case question(delegate: QuestionCellDelegate)
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
            }
        }
        typealias TextFieldComletion = (_ text: String) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .name:
                if let castedCell = cell as? SignUpDataCell {
                    fillNameCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .email:
                if let castedCell = cell as? SignUpDataCell {
                    fillEmailCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .password:
                if let castedCell = cell as? SignUpDataCell {
                    fillPasswordCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .birthday:
                if let castedCell = cell as? SignUpDataCell {
                    fillBirthdayCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .question(let delegate):
                if let castedCell = cell as? QuestionCell {
                    fill(cell: castedCell, delegate: delegate)
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
        
        private func fillNameCell(cell: SignUpDataCell, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Name"
            cell.cellImageview.image            = UIImage(named: "ic_username")
            cell.userDataTextField.sh_setShouldChangeCharactersInRange { (textField, range, string) -> Bool in
                if let text = textField?.text {
                    completion(text)
                }
                return true
            }
        }
        
        private func fillEmailCell(cell: SignUpDataCell, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Email"
            cell.cellImageview.image            = UIImage(named: "email")
            cell.userDataTextField.sh_setShouldChangeCharactersInRange { (textField, range, string) -> Bool in
                if let text = textField?.text {
                    completion(text)
                }
                return true
            }
        }
        
        private func fillPasswordCell(cell: SignUpDataCell, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Password"
            cell.cellImageview.image            = UIImage(named: "ic_password")
            cell.userDataTextField.sh_setShouldChangeCharactersInRange { (textField, range, string) -> Bool in
                if let text = textField?.text {
                    completion(text)
                }
                return true
            }
        }
        
        private func fillBirthdayCell(cell: SignUpDataCell, completion: @escaping TextFieldComletion) {
            cell.userDataTextField.placeholder  = "Birthday"
            cell.cellImageview.image            = UIImage(named: "gift")
            cell.userDataTextField.sh_setShouldChangeCharactersInRange { (textField, range, string) -> Bool in
                if let text = textField?.text {
                    completion(text)
                }
                return true
            }
        }
        
        private func fill(cell: QuestionCell, delegate: QuestionCellDelegate) {
            cell.delegate = delegate
        }
        
        private func fill(cell: ChooseTrainerCell, trainerName: String?) {
            cell.trainerNameLabel.text = trainerName ?? "Select Trainer"
            cell.iconImageView.image   = UIImage(named: "dots")
        }
        
        private func fill(cell: SignUpButtonCell, delegate: SignUpButtonCellDelegate) {
            cell.delegate = delegate
        }
        
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Private
    
    fileprivate func deleteTrainerRow() {
        let indexPath = IndexPath(row:1, section:0)
        self.cellsInfo.remove(at: 1)
        self.signUpTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    fileprivate func insertTrainerRow() {
        let indexPath = IndexPath(row:1, section:0)
        self.cellsInfo.insert(.selectTrainer(trainerName: self.trainer.trainerName), at: 1)
        self.signUpTableView.insertRows(at: [indexPath], with: .fade)
    }
    
    fileprivate func addTrainer(isTrainer: Bool) {
        let indexPath = IndexPath(row:1, section:0)
        if let _ = self.signUpTableView.cellForRow(at: indexPath) as? ChooseTrainerCell {
            if isTrainer {
                deleteTrainerRow()
            }
            
        }else {
            if isTrainer {
                return
            }
            insertTrainerRow()
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
        cellType.fillCell(cell: cell, completion: { text in
            
            switch cellType {
            case .name:
                self.personalData.name       = text
                self.trainerPersonalData?.name       = text
            case .password:
                self.personalData.password   = text
                self.trainerPersonalData?.password       = text
            case .email:
                self.personalData.email      = text
                self.trainerPersonalData?.email       = text
            case .birthday:
                self.personalData.birthday   = text
                self.trainerPersonalData?.birthday       = text
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

private extension SignUpVC {
    
    func setParametersForRequest() {
        
        clientPersonalData.trainerId = 11
    }
    
    func registerClient(){
        setParametersForRequest()
        registerClient { error in
            if error == nil {
                //go to login
            }
        }
    }
    
    func registerTrainer() {
        setParametersForRequest()
        registerTrainer { error in
            if error == nil {
                //go to login
            }
        }
    }
    
    private func registerClient(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        User.registerClient(personalData: personalData, completion: { signUpInfo, error in
            completion(error)
        })
    }
    
    private func registerTrainer(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        Trainer.registerTrainer(personalData: trainerPersonalData!, completion: { signUpInfo, error in
            completion(error)
        })
    }
}

extension SignUpVC: SignUpButtonCellDelegate {
    
    func termsButtonPressed(on cell: SignUpButtonCell) {
        
    }
    
    func signUpButtonPressed(on cell: SignUpButtonCell) {
        setParametersForRequest()
    }
}

extension SignUpVC: QuestionCellDelegate {
    func isTrainer(_ isTrainer: Bool, on cell: QuestionCell) {
        addTrainer(isTrainer: isTrainer)
    }
}

