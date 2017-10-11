//
//  SplashVC.swift
//  Pursuit
//
//  Created by Igor on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    //MARK: Private.Constants
    
    private struct Constants {
        struct SeguesIDs {
            static let Trainer  = "ShowTrainerStoryboard"
            static let Login    = "ShowLoginStoryboard"
            static let Client   = "ShowClientStoryboard"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: checkIfUserLoggedIn() ? "ShowSideMenu"
            : Constants.SeguesIDs.Login, sender: self)
    }
    
    //MARK: Private
    
    private func checkIfUserLoggedIn() -> Bool {
        //return Auth.Token != nil
        return User.shared.token != nil
    }
    
    private func checkUserType() -> String {
        if let clientType = Auth.IsClient {
            if clientType {
                return Constants.SeguesIDs.Client
            } else {
                return Constants.SeguesIDs.Trainer
            }
        }
        return ""
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
