//
//  TrainerCoordinator.swift
//  Pursuit
//
//  Created by ігор on 11/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    //MARK: Coordinator
    
    func start(from controller: UIViewController?) {
        
    }
    
    /// Window to manage
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: - Init
    
    public init(window: UIWindow) {
        self.window = window
        //self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    public func start() {
        
        self.navigateControllers()
    }
    
    private func navigateControllers() {
    
    }
    
    private func checkIfUserLoggedIn() -> Bool {
        return User.shared.token != nil
    }
    
    class func showController(controller: UIViewController) {
        guard let loginController = UIStoryboard.login.MainAuth else { return }
        let controller = controller.navigationController
        controller?.viewControllers.insert(loginController, at: 0)
        
        controller?.popToRootViewController(animated: true)
//        let clientsList = UIStoryboard.trainer.TrainerClients!
//        controller.view.addSubview(clientsList.view)
//        controller.view.addConstraints(UIView.place(clientsList.view, onOtherView: controller.view))
//        clientsList.didMove(toParentViewController: controller)
//        controller.addChildViewController(clientsList)
    }
}

