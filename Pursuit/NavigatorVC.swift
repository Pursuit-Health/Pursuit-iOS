//
//  NavigatorVC.swift
//  Pursuit
//
//  Created by ігор on 10/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class NavigatorVC: UIViewController {
    
    //MARK: Private.Constants
    
    private struct Constants {
        struct SeguesIDs {
            static let Trainer  = "ShowTrainerStoryboard"
            static let Client   = "ShowClientStoryboard"
        }
    }
    
    var userController: UIViewController {
        if isClientType() {
            guard let controller = UIStoryboard.client.ClientTabBar else { return UIViewController() }
            return controller
        }else {
            
            guard let controller = UIStoryboard.trainer.TrainerTabBar else { return UIViewController() }
            return controller
        }
    }
    
    @IBAction func menuBarButtonPressed(_ sender: Any) {
        self.menuButtonPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setAppearence()
        self.addController()
        
        self.revealViewController().delegate = self
        
        self.setUpBackgroundImage()
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            for view in window.subviews {
                if view is TopStatusBarView {
                    view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    //MARK: Private
    
    func coordinate() {
        
    }
    
    private func addController() {
        User.getUserInfo { (user, error) in
            if error == nil {
                if User.shared.coordinator is TrainerCoordinator {
                    
                    
                    let trainerTabBar = UIStoryboard.trainer.TrainerTabBar!
                    
                    self.addChildViewController(trainerTabBar)
                    self.view.addSubview(trainerTabBar.view)
                    self.view.addConstraints(UIView.place(trainerTabBar.view, onOtherView: self.view))
                    trainerTabBar.didMove(toParentViewController: self)
                    //self.leftTitle = "Clients"
                }else {
                    self.leftTitle = User.shared.name ?? ""
                    User.shared.coordinator?.start(from: self)
                }
                
            }else {
                AppCoordinator.showController(controller: self)
            }
        }
    }
    
    func menuButtonPressed() {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
    }
    
    func isClientType() -> Bool {
        if let clientType = UserDefaults.standard.value(forKey: "isClient") as? Bool {
            return clientType
        }
        return false
    }
    
}

extension NavigatorVC: SWRevealViewControllerDelegate {
    func setInteraction(_ enable: Bool) {
        //self.view.isUserInteractionEnabled = enable
        self.view.endEditing(true)
    }
}
