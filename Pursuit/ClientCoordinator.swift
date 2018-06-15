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
    
    //MARK: Properties

    weak var infoVC: ClientInfoVC?
    weak var excersisesVC: TrainingVC?
    weak var excersisesDetailedVC: ExerciseDetailsVC?
    
    //MARK: Coordinator
    
    func start(from controller: UIViewController?) {
        if let controller = controller {
            
            let clientTabBar = UIStoryboard.client.ClientTabBar!
            
            controller.addChildViewController(clientTabBar)
            controller.view.addSubview(clientTabBar.view)
            controller.view.addConstraints(UIView.place(clientTabBar.view, onOtherView: controller.view))
            clientTabBar.didMove(toParentViewController: controller)
            
            ((clientTabBar.viewControllers?[1] as? UINavigationController)?.visibleViewController as? ClientInfoVC)?.delegate = self
        }
    }
    
    func start(from controller: ClientInfoVC, workout: Workout){
        
        User.shared.updateDetailsWorkout(workout: workout) { (excercises, error) in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            } else {
                let training = UIStoryboard.client.Training!
                training.delegate = self
                training.workout = workout
                controller.navigationController?.pushViewController(training, animated: true)
                self.excersisesVC = training
            }
        }
    }
}

extension ClientCoordinator: ClientInfoVCDatasource {
    func loadInfo(controller: ClientInfoVC, completion: @escaping (User, [Workout]?) -> Void) {
        Workout.getWorkouts { (workouts, error) in
            if error == nil {
                if let work = workouts {
                    completion(User.shared, work)
                }
            }
        }
    }
}

extension ClientCoordinator: ClientInfoVCDelegate {
    
    func deleteWorkout(_ workout: Workout, on controller: ClientInfoVC) {
        
    }
    
    func selected(workout: Workout, on controller: ClientInfoVC, client: Client?) {
        User.shared.updateDetailsWorkout(workout: workout) { (excercises, error) in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            } else {
                let training = UIStoryboard.client.Training!
                training.delegate = self
                training.workout = workout
                controller.navigationController?.pushViewController(training, animated: true)
                self.excersisesVC = training
            }
        }
    }
}

extension ClientCoordinator: TrainingVCDelegate {
    func select(excercise: ExcersiseData, on controller: TrainingVC) {
        let details = UIStoryboard.trainer.ExerciseDetails!
        details.excersize = excercise
        details.isInteractiv = false
        details.delegate = self
        controller.navigationController?.pushViewController(details, animated: true)
        self.excersisesDetailedVC = details
    }
}

extension ClientCoordinator: ExerciseDetailsVCDelegate {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC) {
        if let workout = self.excersisesVC?.workout {
            workout.submit(excersise: controller.excersize, completion: { (error) in
                if let error = error {
                    let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                        controller.navigationController?.popViewController(animated: true)
                    }))
                    controller.present(alert, animated: true, completion: nil)
                } else {
                    self.excersisesVC?.recalculate()
                    controller.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            let alert = PSError.somethingWentWrong.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                controller.navigationController?.popViewController(animated: true)
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
