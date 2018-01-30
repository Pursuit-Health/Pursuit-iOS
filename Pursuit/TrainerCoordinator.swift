//
//  TrainerCoordinator.swift
//  Pursuit
//
//  Created by ігор on 11/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SVProgressHUD

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
    var selectedWorkout: Workout?
    var isExerciseSelectedOnCategory: Bool = false
    
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
    }
    
    fileprivate func showError(controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "All fields required for filling!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
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
    func deleteWorkout(_ workout: Workout, on controller: ClientInfoVC) {
        workout.delete(clientId: "\(self.selectedClient?.id ?? 0)") { (error) in
            if error == nil {
                //MBProgressHUD.showAdded(to: controller.view, animated: true).label.text = "Deleted"
                self.clientProfileVC?.updateWorkouts()
            }
        }
    }
    
    
    func selected(workout: Workout, on controller: ClientInfoVC, client: Client?) {
        self.selectedWorkout = workout
        workout.getDetailedTemplateFor(clientId: "\(client?.id ?? 0)", templateId: "\(workout.id ?? 0)") { (exercises, error) in
            if error == nil {
                
                let createTemplate = UIStoryboard.trainer.CreateTemplate!
                
                createTemplate.workoutNew = workout
                createTemplate.delegate = self
                createTemplate.shouldClear = false
                createTemplate.isEditTemplate = true
                self.createTemplate = createTemplate
                //let training = UIStoryboard.client.Training!
                //training.delegate = self
                //training.workout = workout
                controller.navigationController?.pushViewController(createTemplate, animated: true)
            }else {
                
            }
        }
    }
    
    func addWorkoutButtonPressed(on controller: ClientInfoVC) {
        let createTemplate = UIStoryboard.trainer.CreateTemplate!
        createTemplate.delegate = self
        
        controller.navigationController?.pushViewController(createTemplate, animated: true)
        
        self.createTemplate = createTemplate
    }
}

extension TrainerCoordinator: TrainingVCDelegate {
    func select(excercise: ExcersiseData, on controller: TrainingVC) {
        let details = UIStoryboard.trainer.ExerciseDetails!
        details.excersize = excercise
        details.isInteractiv = true
        details.delegate = self
        controller.navigationController?.pushViewController(details, animated: true)
        self.exerciseDetailsVC = details
    }
    
}

extension TrainerCoordinator: CreateTemplateVCDelegate {
    
    func saveWorkout(_ workout: Workout, on controller: CreateTemplateVC) {
        let work = workout
        
        work.excersises = self.createTemplate?.workoutNew?.excersises
        
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
    
    func editWorkout(_ workout: Workout, on controller: CreateTemplateVC) {
        let work = workout
        
        work.excersises = self.createTemplate?.workoutNew?.excersises
        work.editWorkout(clientId: "\(self.selectedClient?.id ?? 0)", templateId: "\(self.selectedWorkout?.id ?? 0)") { (workout, error) in
            if let error = error  {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    self.exercises = []
                }))
                controller.present(alert, animated: true, completion: nil)
            }else {
                controller.navigationController?.popViewController(animated: true)
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
        detailsController.delegate = self
        detailsController.isEditExercise = true
        detailsController.isEdittemplate = self.createTemplate?.isEditTemplate ?? false
        controller.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func deleteWorkoutExercise(_ workout: Workout, exercise: ExcersiseData, on controller: CreateTemplateVC){
        
        workout.deleteExerciseWithId(clientId: "\(self.selectedClient?.id ?? 0)", exerciseId: "\(exercise.id ?? 0)") { (error) in
            if error == nil {
                self.createTemplate?.updateTemplate(client: self.selectedClient)
            }
        }
    }
    
    func closeBarButtonPressed(on controller: CreateTemplateVC) {
        self.exercises = []
        controller.navigationController?.popViewController(animated: true)
    }
}

extension TrainerCoordinator: MainExercisesVCDelegate,  MainExercisesVCDatasource {
    func exerciseSelected(exercise: ExcersiseData.InnerExcersise, controller: MainExercisesVC) {
        let detailsController = UIStoryboard.trainer.ExerciseDetails!
        
        
        let exer = ExcersiseData()
        exer.innerExercise = exercise
        exer.name = exercise.name
        exer.id = exercise.id
        self.isExerciseSelectedOnCategory = true
        detailsController.delegate = self
        
        detailsController.excersize = exer
        controller.navigationController?.pushViewController(detailsController, animated: true)
        self.exerciseDetailsVC = detailsController
    }
    
    func finished(on controller: MainExercisesVC, exercises: [ExcersiseData], state: ControllerState) {
        let work = Workout()
        if state == .customExercise{
            //TODO: Reimplament
            if let ex =  self.mainExercisesVC?.addExercisesVC?.exercise  {
                
                self.checkExerciseRequiredFields(ex, controller: controller)
                
                self.customExercise.append(ex)
                
                self.exercises += self.customExercise
                
                if self.createTemplate?.isEditTemplate ?? false {
                    work.excersises = self.exercises + (self.createTemplate?.workoutNew?.excersises ?? [])
                }else {
                    work.excersises = self.exercises
                }
                self.customExercise = []
            }
        }else {
            
            if self.createTemplate?.isEditTemplate ?? false {
                work.excersises = self.exercises + (self.createTemplate?.workoutNew?.excersises ?? [])
            }else {
                work.excersises = self.exercises
            }
            
        }
        
        work.name = self.createTemplate?.workoutNew?.name
        work.isDone = self.createTemplate?.workoutNew?.isDone
        self.createTemplate?.workoutNew = work
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
        if self.isExerciseSelectedOnCategory {
            self.exercises.append(info)
            self.isExerciseSelectedOnCategory = false
        }else {
            self.searchExercisesVC?.exercise = info
        }
        controller.navigationController?.popViewController(animated: true)
    }
}

extension TrainerCoordinator {
    func checkExerciseRequiredFields(_ ex: ExcersiseData, controller: UIViewController) {
        if (ex.name?.isEmpty ?? true) || ex.sets == nil || ex.reps == nil || ex.weight == nil || ex.rest == nil {
            self.showError(controller: controller)
            return
        }
    }
}
