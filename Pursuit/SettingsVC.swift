//
//  SettingsVC.swift
//  Pursuit
//
//  Created by ігор on 10/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

protocol SettingsVCDelegate: class {
    func logoutPressed(on controller: SettingsVC)
}

class SettingsVC: UIViewController {
    
    //MARK: Properties
    
    weak var delegate: SettingsVCDelegate?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    var user: User? {
        didSet {
            userNameLabel.text = User.shared.name ?? ""
            emailLabel.text = User.shared.email ?? ""
            if User.shared.avatar != nil {
                DispatchQueue.main.async {
                    self.userImageView.sd_setImage(with: URL(string:  PSURL.BaseURL + User.shared.avatar!))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        //TODO: Move to user
        User.shared.token = nil
        guard let loginController = UIStoryboard.login.MainAuth else { return }
        let controller = self.navigationController
        controller?.viewControllers.insert(loginController, at: 0)
        
        controller?.popToRootViewController(animated: true)
    }
    
    func getUserInfo() {
        self.user = User.shared
        
        }
}
