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
    
    lazy var searchExercisesVC: SearchExercisesVC? = {
        guard let searchExercises = UIStoryboard.trainer.SearchExercises else { return UIViewController() as? SearchExercisesVC }
    
        
        return searchExercises
    }()
    
    lazy var addExercisesVC: AddExerceiseVC? = {
        guard let addExercises = UIStoryboard.trainer.AddExercises else { return UIViewController() as? AddExerceiseVC }
   
        
        return addExercises
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setControllers()
        
       self.setUpBackgroundImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController?.navigationBar.setAppearence()
    }
    //MARK: Private
    
    private func setControllers(){
        let controller = TabPageViewController.create()
        
        //controller.tabPageVCDelegate = self
        
        if let searchVC = searchExercisesVC, let aaddExVC = addExercisesVC {
            searchVC.view.backgroundColor = .clear
            aaddExVC.view.backgroundColor = .clear
            controller.tabItems = [(searchVC, "SEARCH"), (aaddExVC, "CUSTOM")]
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
