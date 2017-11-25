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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setAppearence()
        self.addController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.addMenuBarButton()
    }
    
    //MARK: Private
    
    func coordinate() {
        
    }
    
    private func addController() {
        User.getUserInfo { (user, error) in
            if error == nil {
                User.shared.coordinator?.start(from: self)
            }
        }
//        let controller = self.userController
//        self.view.addSubview(controller.view)
//        self.view.addConstraints(UIView.place(controller.view, onOtherView: self.view))
//        controller.didMove(toParentViewController: self)
//        self.addChildViewController(controller)
    }
    
    func addMenuBarButton() {
            let menuButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(self.menuButtonPressed))
            
            menuButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func menuButtonPressed() {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
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
    
    func isClientType() -> Bool {
        if let clientType = UserDefaults.standard.value(forKey: "isClient") as? Bool {
            return clientType
        }
        return false
    }
    
}
