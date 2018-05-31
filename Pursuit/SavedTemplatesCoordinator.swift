//
//  SavedTemplatesCoordinator.swift
//  Pursuit
//
//  Created by Igor on 5/24/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class SavedTemplatesCoordinator: Coordinator {
    
    weak var savedTemplates: SavedTemplatesVC?
    
    var selectedCategory: Category?
    
    var exercises: [ExcersiseData] = []
    
    var customExercises: [ExcersiseData] = []
    
    weak var savedTemplateVC: SavedTemplateVC?
    
    weak var mainExercisesVC: MainExercisesVC?
    
    weak var searchExercisesVC: ExercisesSearchVC?
    
    weak var exerciseDetailsVC: ExerciseDetailsVC?
    
    var isExerciseSelectedOnCategory: Bool = false
    
    func start(from controller: UIViewController?) {
        let savedTemplates = UIStoryboard.trainer.SavedTemplatesList!
        savedTemplates.delegate = self
        self.savedTemplates = savedTemplates
        controller?.navigationController?.pushViewController(savedTemplates, animated: true)        
    }
}

extension SavedTemplatesCoordinator: SavedTemplatesVCDelegate {
    
    func addNewTemplate(on controller: SavedTemplatesVC) {
        let createSavedTemplate = UIStoryboard.trainer.SavedTemplate!
        createSavedTemplate.delegate = self
        self.savedTemplateVC = createSavedTemplate
        controller.navigationController?.pushViewController(createSavedTemplate, animated: true)
    }
    
    func didSelectTemplate(_ template: SavedTemplateModel, on controller: SavedTemplatesVC) {
        let createSavedTemplate = UIStoryboard.trainer.SavedTemplate!
        createSavedTemplate.savedTemplate = template
        createSavedTemplate.delegate = self
        self.savedTemplateVC = createSavedTemplate
        controller.navigationController?.pushViewController(createSavedTemplate, animated: true)
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

extension SavedTemplatesCoordinator: SavedTemplateVCDelegate {
    
    func addExercisesButtonPressed(on controller: SavedTemplateVC) {
        let mainExercises = UIStoryboard.trainer.MainExercises!
        
        mainExercises.delegate = self
        mainExercises.datasource = self
        controller.navigationController?.pushViewController(mainExercises, animated: true)
        
        self.mainExercisesVC = mainExercises
    }
    
    func exerciseSelected(exercise: ExcersiseData, on controller: SavedTemplateVC) {
        let detailsController = UIStoryboard.trainer.ExerciseDetails!
        detailsController.excersize = exercise
        detailsController.delegate = self
        detailsController.isEditExercise = true
        detailsController.isEdittemplate = self.savedTemplateVC?.savedTemplate?.id != nil 
        controller.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func saveTemplate(_ template: SavedTemplateModel, on controller: SavedTemplateVC) {
        SavedTemplateModel.saveSavedTemplate(template: template) { (error) in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }else {
                controller.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func editTemplate(_ template: SavedTemplateModel, on controller: SavedTemplateVC) {
        SavedTemplateModel.editSavedTemplate(templateId: "\(template.id ?? 0)", template: template) { error in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }else {
                controller.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func deleteTemplateExercise(_ template: SavedTemplateModel, exercise: ExcersiseData, on controller: SavedTemplateVC) {
        SavedTemplateModel.editSavedTemplate(templateId: "\(template.id ?? 0)", template: template) { error in
            if let error = error {
                let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }else {
                controller.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func closeBarButtonPressed(on controller: SavedTemplateVC) {
        controller.navigationController?.popViewController(animated: true)
    }
}

extension SavedTemplatesCoordinator: MainExercisesVCDelegate,  MainExercisesVCDatasource {
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
        if state == .customExercise {
            if let ex =  self.mainExercisesVC?.addExercisesVC?.exercise  {
                if  ex.sets_count == nil {
                    ex.sets = []
                }
                self.customExercises.append(ex)
                
                self.exercises += self.customExercises
                self.customExercises = []
            }
        }else {
            self.exercises.append(contentsOf: exercises)
        }
        
        if self.savedTemplateVC?.savedTemplate?.exercises == nil {
            self.savedTemplateVC?.savedTemplate?.exercises = []
        }
        
        for ex in self.exercises {
            ex.sets = ex.sets.flatMap{ $0 }
        }
        
        self.savedTemplateVC?.savedTemplate?.exercises?.append(contentsOf: self.exercises)
        //self.savedTemplateVC?.recalculate()
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

extension SavedTemplatesCoordinator: ExercisesSearchVCDelegate, ExercisesSearchVCDatasource {
    
    func loadExercisesByCategoryId(on controller: ExercisesSearchVC, completion: @escaping ExercisesSearchVCDatasource.GetExercisesByCategoryIdCompletion) {
        self.selectedCategory?.loadExercisesByCategoryId(completion: { (innerexercises, error) in
            if error == nil {
                completion(innerexercises)
            }else {
                completion(nil)
            }
        })
    }
    
    func endedWithExercises(_ exercises: [ExcersiseData], on controller: ExercisesSearchVC) {
        //upload workout
        self.exercises += exercises
        controller.navigationController?.popViewController(animated: true)
    }
    
    func didSelectExercise(exercise: ExcersiseData, on controller: ExercisesSearchVC) {
        let detailsController = UIStoryboard.trainer.ExerciseDetails!
        detailsController.delegate = self
        detailsController.excersize = exercise
        controller.navigationController?.pushViewController(detailsController, animated: true)
        self.exerciseDetailsVC = detailsController
    }
}

extension SavedTemplatesCoordinator: ExerciseDetailsVCDelegate {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC) {
        if self.isExerciseSelectedOnCategory {
            self.exercises.append(info)
            self.isExerciseSelectedOnCategory = false
        }else {
            self.searchExercisesVC?.exercise = info
        }
        controller.navigationController?.popViewController(animated: true)
    }
}
