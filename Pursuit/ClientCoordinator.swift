//
//  ClientCoordinator.swift
//  Pursuit
//
//  Created by ігор on 11/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import UIKit

class ClientCoordinator: Coordinator {

    override init() {
        super.init()
    }
    var childCoordinators: [Coordinator] = []
    
    var controller: UIViewController {
        return  UIStoryboard.client.ClientTabBar ?? UIViewController()
    }
    
    override public func showController(on superController:  UIViewController) {
        
        let controller = self.controller
        superController.view.addSubview(controller.view)
        superController.view.addConstraints(UIView.place(controller.view, onOtherView: superController.view))
        controller.didMove(toParentViewController: superController)
        superController.addChildViewController(controller)
    }
    
}
