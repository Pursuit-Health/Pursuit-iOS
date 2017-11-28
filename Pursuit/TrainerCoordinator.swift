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
    weak var mainExercisesVC: MainExercisesVC?
    weak var searchExercisesVC: ExercisesSearchVC?
    weak var exerciseDetailsVC: ExerciseDetailsVC?
    
    var selectedCategory: Category?
    var exercises: [ExcersiseData] = []
    var customExercise: [ExcersiseData] = []
    
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
    
    func saveWorkout(_ workout: Workout, on controller: CreateTemplateVC) {
        var work = workout
        
        work.excersises = self.exercises
        
        work.createWorkout(clientId: "\(self.selectedClient?.id ?? 0)") { (workout, error) in
            if error == nil {
                self.exercises = []
                controller.navigationController?.popViewController(animated: true)
            }else {
                let alert = error?.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                }))
                controller.present(alert!, animated: true, completion: nil)
            }
        }
    }

    func addExercisesButtonPressed(on controller: CreateTemplateVC) {
        let mainExercises = UIStoryboard.trainer.MainExercises!
        
        mainExercises.delegate = self
        mainExercises.datasource = self
        controller.navigationController?.pushViewController(mainExercises, animated: true)
        
        self.mainExercisesVC = mainExercises
    }
    
    func exerciseSelected(exercise: ExcersiseData, on controller: CreateTemplateVC) {
        let detailsController = UIStoryboard.trainer.ExerciseDetails!
        detailsController.excersize = exercise
        detailsController.isEditExercise = true
        controller.navigationController?.pushViewController(detailsController, animated: true)
    }
    
}

extension TrainerCoordinator: MainExercisesVCDelegate,  MainExercisesVCDatasource {
    func finished(on controller: MainExercisesVC, exercises: [ExcersiseData], state: ControllerState) {
        
        if state == .customExercise{
            
            if let ex =  self.mainExercisesVC?.addExercisesVC?.exercise  {
            self.customExercise.append(ex)
                let work = Workout()
                work.excersises = self.customExercise
                self.createTemplate?.workoutNew = work
            }
        }else {
            let work = Workout()
            work.excersises = self.exercises
            self.createTemplate?.workoutNew = work
        }
        controller.navigationController?.popViewController(animated: true)
    }
    
    func customexerciseAdded(exercise: ExcersiseData, on controller: MainExercisesVC, state: ControllerState) {
        
    }
    
    
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
        self.exerciseDetailsVC = detailsController
    }
    
    func endedWithExercises(_ exercises: [ExcersiseData], on controller: ExercisesSearchVC) {
        //upload workout
        self.exercises += exercises
        controller.navigationController?.popViewController(animated: true)
    }

    func loadExercisesByCategoryId(on controller: ExercisesSearchVC, completion: @escaping ExercisesSearchVCDatasource.GetExercisesByCategoryIdCompletion) {
        self.selectedCategory?.loadExercisesByCategoryId(completion: { (innerexercises, error) in
            if error == nil {
                completion(innerexercises)
            }else {
                completion(nil)
            }
        })
    }
}

extension TrainerCoordinator: ExerciseDetailsVCDelegate {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC) {
        //self.exercises.append(info)
        self.searchExercisesVC?.exercise = info
        controller.navigationController?.popViewController(animated: true)
    }
}
