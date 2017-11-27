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
    weak var createTemplate: CreateTemplateVC?
    weak var addExercisesVC: MainExercisesVC?
    weak var searchExercisesVC: ExercisesSearchVC?
    
    var selectedCategory: Category?
    
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
    
    func addWorkoutButtonPressed(on controller: ClientInfoVC) {
        let createTemplate = UIStoryboard.trainer.CreateTemplate!
        createTemplate.delegate = self
        
        controller.navigationController?.pushViewController(createTemplate, animated: true)
        
        self.createTemplate = createTemplate
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
    
    func selected(workout: Workout, on controller: ClientInfoVC, client: Client?) {
        workout.getDetailedTemplateFor(clientId: "\(client?.id ?? 0)", templateId: "\(workout.id ?? 0)") { (exercises, error) in
            if error == nil {
                
                let training = UIStoryboard.client.Training!
                training.delegate = self
                training.workout = workout
                controller.navigationController?.pushViewController(training, animated: true)
            }else {
                
            }
        }
    }
}

extension TrainerCoordinator: TrainingVCDelegate {
    func select(excercise: ExcersiseData, on controller: TrainingVC) {
   
    }

}

extension TrainerCoordinator: CreateTemplateVCDelegate {
    
    func saveTemplate(_ template: Template, on controllers: CreateTemplateVC) {
        
    }
    
    func addExercisesButtonPressed(on controller: CreateTemplateVC) {
        let mainExercises = UIStoryboard.trainer.MainExercises!
        
        mainExercises.delegate = self
        mainExercises.datasource = self
        controller.navigationController?.pushViewController(mainExercises, animated: true)
        
        self.addExercisesVC = mainExercises
    }
}

extension TrainerCoordinator: MainExercisesVCDelegate,  MainExercisesVCDatasource {
    
    func categorySelected(category: Category, controller: MainExercisesVC) {
        let exercisesSearchVc = UIStoryboard.trainer.ExercisesSearch!
        self.selectedCategory = category
        exercisesSearchVc.delegate = self
        exercisesSearchVc.category      = category
        exercisesSearchVc.datasource    = self
        self.searchExercisesVC = exercisesSearchVc
        controller.navigationController?.pushViewController(exercisesSearchVc, animated: true)
    }
    
    func loadInfoFor(controller: ExerciseCategoryVC, completion: @escaping MainExercisesVCDatasource.GetTrainerCategories) {
        Trainer.getCategories { (categories, error) in
            if error == nil {
                completion(categories)
            }else {
                completion(nil)
            }
        }
    }
}

extension TrainerCoordinator: ExercisesSearchVCDatasource, ExercisesSearchVCDelegate {
    func didSelectExercise(exercise: ExcersiseData, on controller: ExercisesSearchVC) {
        let detailsController = UIStoryboard.trainer.ExerciseDetails!
        detailsController.delegate = self
        detailsController.excersize = exercise
        controller.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func endedWithExercises(_ exercises: [ExcersiseData], on controller: ExercisesSearchVC) {
        Template.cre
    }

    func loadExercisesByCategoryId(on controller: ExercisesSearchVC, completion: @escaping ExercisesSearchVCDatasource.GetExercisesByCategoryIdCompletion) {
        self.selectedCategory?.loadExercisesByCategoryId(completion: { (exercises, error) in
            if error == nil {
                completion(exercises)
            }else {
                completion(nil)
            }
        })
    }
}

extension TrainerCoordinator: ExerciseDetailsVCDelegate {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC) {
        self.searchExercisesVC?.exercise = info
        controller.navigationController?.popViewController(animated: true)
    }
}
