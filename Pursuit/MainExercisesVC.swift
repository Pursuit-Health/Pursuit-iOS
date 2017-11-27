//
//  MainExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol MainExercisesVCDelegate: class  {
    func categorySelected(category: Category, controller: MainExercisesVC)
}

protocol MainExercisesVCDatasource: class {
    typealias GetTrainerCategories = (_ categories: [Category]?) -> Void
    
    func loadInfoFor(controller: ExerciseCategoryVC, completion: @escaping GetTrainerCategories)
}

class MainExercisesVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet var viewForControllers: UIView!
    
    //MARK: Variables
    
    weak var delegate: MainExercisesVCDelegate?
    weak var datasource: MainExercisesVCDatasource?
    
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
    
    @IBAction func saveExercisesButtonPressed(_ sender: Any) {
        
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
            exercisesVC.datasource = self
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
    func didSelectCategory(category: Category, on controller: ExerciseCategoryVC) {
        self.delegate?.categorySelected(category: category, controller: self)
    }
}

extension MainExercisesVC: ExerciseCategoryVCDatasource {
    func loadInfo(controller: ExerciseCategoryVC, completion: @escaping ExerciseCategoryVCDatasource.GetTrainerCategories) {
        self.datasource?.loadInfoFor(controller: controller, completion: { (categories) in
            completion(categories)
        })
    }
}
