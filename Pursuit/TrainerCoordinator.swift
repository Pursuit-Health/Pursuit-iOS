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
import SimpleAlert

class TrainerCoordinator: Coordinator {
    
    weak var clientsListVC: ClientsVC?
    weak var clientProfileVC: ClientInfoVC?
    weak var selectedClient: Client?
    weak var createTemplate: CreateNewTemplateVC?
    weak var mainExercisesVC: MainExercisesVC?
    weak var searchExercisesVC: ExercisesSearchVC?
    weak var exerciseDetailsVC: ExerciseDetailsVC?
    weak var savedTemplateVC: SavedTemplateVC?
    
    var selectedCategory: Category?
    var exercises: [ExcersiseData] = []
    var savedTemplateExercises: [ExcersiseData] = [] {
        didSet {
            let temp = SavedTemplateModel()
            temp.exercises = self.savedTemplateExercises
            savedTemplateVC?.savedTemplate = temp
        }
    }
    var customExercise: [ExcersiseData] = []
    var selectedWorkout: Workout?
    var isExerciseSelectedOnCategory: Bool = false
    
    func start(from controller: UIViewController?) {
        if let controller = controller {
            
            let trainerTabBar = UIStoryboard.trainer.TrainerTabBar!
            
            controller.addChildViewController(trainerTabBar)
            controller.view.addSubview(trainerTabBar.view)
            controller.view.addConstraints(UIView.place(trainerTabBar.view, onOtherView: controller.view))
            trainerTabBar.didMove(toParentViewController: controller)
            
            
//            let clientsList = UIStoryboard.trainer.TrainerClients!
//            clientsList.delegate = self
//            controller.view.addSubview(clientsList.view)
//            controller.view.addConstraints(UIView.place(clientsList.view, onOtherView: controller.view))
//            clientsList.didMove(toParentViewController: controller)
//            controller.addChildViewController(clientsList)
//
//            self.clientsListVC = clientsList
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
    
    func showSavedTemplatesVC(on controller: ClientsVC) {
        let savedTemplatesVC = UIStoryboard.trainer.SavedTemplatesList!
        savedTemplatesVC.delegate = self
        controller.navigationController?.pushViewController(savedTemplatesVC, animated: true)
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
                
                let createTemplate = UIStoryboard.trainer.CreateNewTemplate!
                
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
        
        let action = PSActionSheet(title: nil, message: "Add Template", style: .actionSheet).addAction(action: AlertAction(title: "Create New", style: .default, handler: { _ in
            let createTemplate = UIStoryboard.trainer.CreateNewTemplate!
            createTemplate.delegate = self
            createTemplate.shouldClear = true
            self.createTemplate = createTemplate
            controller.navigationController?.pushViewController(createTemplate, animated: true)
        })).addAction(action: AlertAction(title: "Use Saved Template", style: .default, handler: { _ in
            let savedTemplatesVC = UIStoryboard.trainer.SavedTemplatesList!
            savedTemplatesVC.delegate = self
            savedTemplatesVC.canAddNewTemplate = false
            
            controller.navigationController?.pushViewController(savedTemplatesVC, animated: true)
            
        })).addAction(action: AlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        controller.present(action, animated: true, completion: nil)
        

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
        for exerc in exercises {
            if exerc.sets_count == nil {
                exerc.sets = []
            }
            exerc.sets = exerc.sets.flatMap{ $0 }
        }
        
        let work = Workout()
        if state == .customExercise{
            //TODO: Reimplament
            if let ex =  self.mainExercisesVC?.addExercisesVC?.exercise  {
                if  ex.sets_count == nil {
                    ex.sets = []
                }
                ex.sets = ex.sets.flatMap{ $0 }
                
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
                work.id = self.createTemplate?.workoutNew?.id
            }else {
                
                work.excersises  = (self.createTemplate?.exercises ?? []) + self.exercises
            }
            
        }
        
        work.name = self.createTemplate?.workoutNew?.name
        work.isDone = self.createTemplate?.workoutNew?.isDone
        self.createTemplate?.workoutNew = work
        self.exercises = []
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
        if (ex.name?.isEmpty ?? true) || ex.sets == nil || ex.rest == nil {
            self.showError(controller: controller)
            return
        }
    }
}

extension TrainerCoordinator: SavedTemplatesVCDelegate {

    func addNewTemplate(on controller: SavedTemplatesVC) {
//        let createSavedTemplate = UIStoryboard.trainer.SavedTemplate!
//        createSavedTemplate.delegate = self
//        //self.savedTemplateVC = createSavedTemplate
//        controller.navigationController?.pushViewController(createSavedTemplate, animated: true)
    }
    
    func didSelectTemplate(_ template: SavedTemplateModel, on controller: SavedTemplatesVC) {

            let createNewTemplate = UIStoryboard.trainer.CreateNewTemplate!
        
            createNewTemplate.delegate = self
            createNewTemplate.workoutNew = Workout()
            createNewTemplate.workoutNew?.name = template.name
            createNewTemplate.workoutNew?.notes = template.notes
            createNewTemplate.workoutNew?.excersises = template.exercises
            createNewTemplate.workoutNew?.isDone = nil
            createNewTemplate.shouldClear = false
            createNewTemplate.isEditTemplate = true
            self.createTemplate = createNewTemplate
            controller.navigationController?.pushViewController(createNewTemplate, animated: true)
    }
    
    func deleteTemplate(template: SavedTemplateModel, on controller: SavedTemplatesVC) {
        SavedTemplateModel.deleteSavedTemplate(templateId: "\(template.id ?? 0)") { error in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }else {
                controller.updateDataSource()
            }
        }
    }

    func closeBarButtonPressed(on controller: SavedTemplatesVC) {
        controller.navigationController?.popViewController(animated: true)
    }
}
