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
    
    weak var clientsListVC: ClientsVC?
    weak var clientProfileVC: ClientInfoVC?
    weak var selectedClient: Client?
    
    func start(from controller: UIViewController?) {
        if let controller = controller {
            let clientsList = UIStoryboard.trainer.TrainerClients!
            clientsList.delegate = self
            controller.view.addSubview(clientsList.view)
            controller.view.addConstraints(UIView.place(clientsList.view, onOtherView: controller.view))
            clientsList.didMove(toParentViewController: controller)
            controller.addChildViewController(clientsList)
            
            self.clientsListVC = clientsList
        }
        //        superController.navigationController?.pushViewController(self.controller, animated: true)
//        let controller = self.controller
//        superController.view.addSubview(controller.view)
//        superController.view.addConstraints(UIView.place(controller.view, onOtherView: superController.view))
//        controller.didMove(toParentViewController: superController)
//        superController.addChildViewController(controller)
    }
    
}

extension TrainerCoordinator: ClientsVCDelegate {
    func didSelect(client: Client, on controller: ClientsVC) {
        let clientInfo = UIStoryboard.trainer.ClientInfo!
        clientInfo.delegate = self
        clientInfo.dataSource = self
        self.selectedClient = client
        controller.navigationController?.pushViewController(clientInfo, animated: true)
        
        self.clientProfileVC = clientInfo
    }
}

extension TrainerCoordinator: ClientInfoVCDatasource {
    func loadInfo(controller: ClientInfoVC, completion: @escaping (User, [Workout]?) -> Void) {
        self.selectedClient?.getTemplatesAsTrainer(completion: { (workouts, error) in
            if error == nil {
                if let client = self.selectedClient, let work = workouts {
                    completion(client, work)
                }
            }
        })
    }
}

extension TrainerCoordinator: ClientInfoVCDelegate {
    func selected(workout: Workout, on controller: ClientInfoVC) {
//        User.shared.updateDetailsWorkout(workout: workout) { (excercises, error) in
//            if let error = error {
//                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                controller.present(alert, animated: true, completion: nil)
//            } else {
//                let training = UIStoryboard.client.Training!
//                training.delegate = self
//                training.workout = workout
//                controller.navigationController?.pushViewController(training, animated: true)
//                self.excersisesVC = training
//            }
//        }
    }
}
