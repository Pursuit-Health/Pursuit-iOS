//
//  TrainerCoordinator.swift
//  Pursuit
//
//  Created by ігор on 11/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import UIKit

class TrainerCoordinator: Coordinator {
    
    var controller: UIViewController {
        return  UIStoryboard.trainer.TrainerClients ?? UIViewController()
    }
    
    func start(from controller: UIViewController?) {
        
//        superController.navigationController?.pushViewController(self.controller, animated: true)
//        let controller = self.controller
//        superController.view.addSubview(controller.view)
//        superController.view.addConstraints(UIView.place(controller.view, onOtherView: superController.view))
//        controller.didMove(toParentViewController: superController)
//        superController.addChildViewController(controller)
    }
    
}
