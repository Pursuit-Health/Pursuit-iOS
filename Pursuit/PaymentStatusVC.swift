//
//  PaymentStatusVC.swift
//  Pursuit
//
//  Created by ігор on 7/9/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SimpleAlert

class PaymentStatusVC: UIViewController {

    var authError: AppCoordinator.AuthError = .none
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
        
        setupUI()
        
    }
    
    private func setupUI() {
        messageLabel.text   = authError.message
        leftTitle           = authError.leftTitle
    }
    
    private func updateTitlelabel(_ title: String) {
        titleLabel.text = title
    }
    
    private func changeTrainerWithNewCode(_ trainerCode: String) {
        Client.changeTrainer(trainerCode: trainerCode.uppercased()) { (error) in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                self.updateTitlelabel("Trainer has been changed.")
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Change Trainer", message: "Enter a code", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Trainer Code?"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let code = alert?.textFields?.first?.text {
                self.changeTrainerWithNewCode(code)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func menuBarButtonPressed(_ sender: Any) {
        if let sideMenu = self.revealViewController() {
            sideMenu.revealToggle(self)
        }
    }
    
    @IBAction func changeTrainerButtonPressed(_ sender: Any) {
        showAlert()
    }
}
