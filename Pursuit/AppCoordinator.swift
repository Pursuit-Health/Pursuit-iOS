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
    
    //MARK: Enum
    
    enum AuthError: Int {
        case none = 401
        case pending = 10001
        case rejected = 10002
        case deleted = 10006
        case paymentrequired = 10003
        case subscriptionExpired = 10004
        
//        ublic const REQUEST_PENDING = 10001;
//        public const REQUEST_REJECTED = 10002;
//        public const PLAN_UPGRADE_NEEDED = 10003;
//        public const SUBSCRIPTION_EXPIRED = 10004;
//        public const ALREADY_ACCEPTED = 10005;
//        public const REQUEST_DELETED = 10006;
        
        var message: String {
            switch self {
            case .none:
                return ""
            case .pending:
                return "Waiting for Trainer Approval"
            case .rejected:
                return "You request has been rejected."
            case .deleted:
                return "Trainer deleted you as a Client"
            case .paymentrequired:
                return  "You have reached limit of clients"
            case .subscriptionExpired:
                return "Your subscription has expired!.Please register for one of our plans in order to continue using Pursuit Health with your clients."
            }
        }
        
        var leftTitle: String {
            switch self {
            case .none:
                return ""
            case .pending:
                return "Review"
            case .rejected:
                return "Rejected"
            case .deleted:
                return "Deleted"
            case .paymentrequired:
                return "Payment Required"
            case .subscriptionExpired:
                return "Subscription Expired"
            }
        }
    }
    
    static public var shared = AppCoordinator()
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: - Init
    
     init() {

    }
    
    public func start() {
        self.navigateControllers()
    }
    
    private func navigateControllers() {
    
    }
    
    private func checkIfUserLoggedIn() -> Bool {
        return User.shared.token != nil
    }
    
    private func handle(error: ErrorProtocol, on controller: NavigatorVC) {
        guard let appError = AuthError(rawValue: error.statusCode) else { return }
        
        guard let paystatusVC = UIStoryboard.client.PaymentStatus else { return }
        let navigation = UINavigationController(rootViewController: paystatusVC)
        paystatusVC.authError = appError
        controller.addChildViewController(navigation)
        controller.view.addSubview(navigation.view)
        controller.view.addConstraints(UIView.place(navigation.view, onOtherView: controller.view))
        navigation.didMove(toParentViewController: navigation)
    }
    
     func showController(controller: UIViewController) {
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
    
    
     func start(from: NavigatorVC, with error: ErrorProtocol) {
        handle(error: error, on: from)
    }
}

