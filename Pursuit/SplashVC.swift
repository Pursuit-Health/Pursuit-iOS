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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        User.token = nil
        self.performSegue(withIdentifier: checkIfUserLoggedIn() ? Constants.SeguesIDs.Trainer: Constants.SeguesIDs.Login, sender: self)
    }
    
    //MARK: Private
    
    private func checkIfUserLoggedIn() -> Bool {
        return User.token != nil
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
