//
//  MainExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class MainExercisesVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet var viewForControllers: UIView!
    
    //MARK: Variables
    lazy var exercisesSearchVC: ExercisesSearchVC? = {
        guard let exercisesSearchVc = UIStoryboard.trainer.ExercisesSearch else { return UIViewController() as? ExercisesSearchVC }
        return exercisesSearchVc
    }()
    
    lazy var exercisesCategoryVC: ExerciseCategoryVC? = {
        guard let exercisesCategory = UIStoryboard.trainer.ExerciseCategory else { return UIViewController() as? ExerciseCategoryVC }
    
        
        return exercisesCategory
    }()
    
    lazy var addExercisesVC: AddExerceiseVC? = {
        guard let addExercises = UIStoryboard.trainer.AddExercises else { return UIViewController() as? AddExerceiseVC }
   
        
        return addExercises
    }()
    
    //MARK: IBActions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
       self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setControllers()
        
       self.setUpBackgroundImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    //MARK: Private
    
    private func setControllers(){
        let controller = TabPageViewController.create()
        
        //controller.tabPageVCDelegate = self
        
        if let exercisesVC = exercisesCategoryVC, let aaddExVC = addExercisesVC {
            exercisesVC.delegate = self
            exercisesVC.view.backgroundColor    = .clear
            aaddExVC.view.backgroundColor       = .clear
            controller.tabItems = [(exercisesVC, "SEARCH"), (aaddExVC, "CUSTOM")]
        }
        
        setUpOptions(controller)
        
        setUpControllerToMainView(controller)
        
    }
    
    private func setUpOptions(_ controller: TabPageViewController) {
        var option                  = TabPageOption()
        option.currentBarHeight     = 3.0
        option.tabWidth             = view.frame.width / CGFloat(controller.tabItems.count)
        option.tabBackgroundColor   = .clear
        option.tabBackgroundImage   = UIImage()
        option.currentColor         = UIColor.customAuthButtons()
        controller.option           = option
    }
    
    private func setUpControllerToMainView(_ controller: TabPageViewController) {
        addChildViewController(controller)
        self.viewForControllers.addSubview(controller.view)
        self.viewForControllers.addConstraints(UIView.place(controller.view, onOtherView: viewForControllers))
        
        controller.didMove(toParentViewController: self)
    }
}

extension MainExercisesVC: ExerciseCategoryVCDelegate {
    func didSelectExercise(exercise: Template.Exercises, on controller: ExerciseCategoryVC) {
        guard let searchExercisesVC = self.exercisesSearchVC else {
            return
        }
        searchExercisesVC.exercise = exercise
        
        self.navigationController?.pushViewController(searchExercisesVC, animated: true)
        
    }
}
