//
//  ClientTemlatesVC.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ClientTemlatesVC: UIViewController {
    
    @IBOutlet weak var clientTemplateTableView: UITableView! {
        didSet {
            self.clientTemplateTableView.rowHeight = 71.0
        }
    }
    
    var workoutsData: [Workout] = [] {
        didSet {
            self.clientTemplateTableView.reloadData()
        }
    }
    
    var workoutId: String?
    
    lazy var clientWorkoutVC: TrainingVC? = {
        let storyboard = UIStoryboard(name: Storyboards.Client, bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: Controllers.Identifiers.ClientWorkout)as? UINavigationController)?.visibleViewController as? TrainingVC
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setAppearence()
        
        self.setUpBackgroundImage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false 
        
        getWorkouts()
    }
    
    func pushClientWorkoutVC() {
        guard let controller = clientWorkoutVC else { return }
        controller.workoutId = self.workoutId
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getWorkouts() {
        Workout.getWorkouts { (workouts, error) in
            if error == nil {
                if let work = workouts {
                    self.workoutsData = work
                }
            }
        }
    }
    
}

extension ClientTemlatesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TemplateCell.self) else { return UITableViewCell() }
        let workout = workoutsData[indexPath.row]
        cell.templateNameLabel.text = workout.template?.name
        cell.templateTimeLabel.text = "\(workout.template?.time ?? 0)" + " minutes"
        return cell
    }
}

extension ClientTemlatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workoutsData[indexPath.row]
        if let id = workout.id {
            self.workoutId = "\(id)"
            
            pushClientWorkoutVC()
        }
    }
}

