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
    
    private var userController: UIViewController {
        if isClientType() {
            guard let controller = UIStoryboard.client.ClientTabBar else { return UIViewController() }
            return controller
        }else {
            
            guard let controller = UIStoryboard.trainer.TrainerTabBar else { return UIViewController() }
            return controller
        }
    }
    
    var tabBarVC: UITabBarController?
    
    @IBAction func menuBarButtonPressed(_ sender: Any) {
        self.menuButtonPressed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setAppearence()
        
        self.navigate()
        
        self.revealViewController().delegate = self
        
        self.setUpBackgroundImage()
        
        self.setupSideMenu()
        
        self.setupTopView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK: Private
    
    func coordinate() {
        
    }
    
    private func setupSideMenu() {
        if let sideMenu = self.revealViewController() {
            view.addGestureRecognizer(sideMenu.panGestureRecognizer())
            view.addGestureRecognizer(sideMenu.tapGestureRecognizer())
        }
    }
    
    private func addController(controller: UIViewController) {
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        self.view.addConstraints(UIView.place(controller.view, onOtherView: self.view))
        controller.didMove(toParentViewController: self)
    }
    
    private func setupTopView() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            for view in window.subviews {
                if view is TopStatusBarView {
                    view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
                }
            }
        }
    }
    
    private func isClientAllowed(completion: @escaping (ErrorProtocol?) -> ()){
        Client.check { (error) in
            completion(error)
        }
    }
    
    private func navigateTrainer() {
        let trainerTabBar = UIStoryboard.trainer.TrainerTabBar!
        self.tabBarVC = trainerTabBar
        self.addController(controller: trainerTabBar)
    }
    
    private func navigateClient() {
        let clientTabBar = UIStoryboard.client.ClientTabBar!
        self.addController(controller: clientTabBar)
        self.leftTitle = User.shared.name ?? ""
    }
    
    private func getFirebaseToken() {
        User.getFireBaseToken { (_, error) in
            
        }
    }
    
    private func navigate() {

        User.getUserInfo { (user, error) in
            if let _ = error {
                AppCoordinator.shared.showController(controller: self)
            }else {
                if User.shared.coordinator is TrainerCoordinator {
                    self.getFirebaseToken()
                    self.navigateTrainer()
                }else {
                    self.isClientAllowed(completion: { (clientError) in
                        if let clientError = clientError {
                            AppCoordinator.shared.start(from: self, with: clientError)
                        }else {
                            self.getFirebaseToken()
                            self.navigateClient()
                        }
                    })
                }
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
