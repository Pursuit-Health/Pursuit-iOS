//
//  TrainingVC.swift
//  Pursuit
//
//  Created by ігор on 8/4/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainingVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var todoLabel        : UILabel!
    @IBOutlet weak var completedLabel   : UILabel!
    @IBOutlet weak var monthYearLabel   : UILabel!
    @IBOutlet weak var dayDigitLabel    : UILabel!
    @IBOutlet weak var dayNameLabel     : UILabel!
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            self.submitButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var trainingTableView: UITableView! {
        didSet{
            trainingTableView.rowHeight             = UITableViewAutomaticDimension
            trainingTableView.estimatedRowHeight    = 200
        }
    }
    
    //MARK: Variables
    
    var dateformatter = DateFormatters.serverTimeFormatter
    
    var workoutId: String?
    
    var workout: Workout? {
        didSet {
            self.completedLabel.text    = "0"
            self.completedCount          = 0
            
            guard let dayCur  = self.workout?.currentWorkDay else { return }
            guard let dateS = dateformatter.date(from: dayCur) else { return }
            
            //TODO: Move to separate method
            dateformatter.dateFormat = "EEEE"
            let dayOfWeak: String = dateformatter.string(from: dateS)
            dateformatter.dateFormat = "MMMM yyyy"
            let monthYear: String = dateformatter.string(from: dateS)
            dateformatter.dateFormat = "dd"
            let digitOfDay: String = dateformatter.string(from: dateS)
            
            self.dayNameLabel.text = dayOfWeak
            self.dayDigitLabel.text = digitOfDay
            self.monthYearLabel.text = monthYear
            
            self.trainingTableView?.reloadData()
        }
    }
    
    var exercises: [Template.Exercises] = [] {
        didSet {
            self.trainingTableView?.reloadData()
            self.todoLabel.text = "\(self.exercises.count)"
            
            if exercises.count == 0 {
                self.submitButton.isEnabled = true
            }
        }
    }
    
    var completedCount: Int = 0 {
        didSet {
            self.completedLabel.text = "\(self.completedCount)"
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.submitWorkout()
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        self.navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        getWorkoutById()
    }
    
    fileprivate func getWorkoutById() {
        Workout.getWorkoutById(workoutId: workoutId ?? "") { (workout, error) in
            if error == nil {
                if let workoutUn = workout {
                    self.workout = workoutUn
                    self.exercises = workoutUn.template?.exercises ?? []
                }
            }
        }
    }
    
    fileprivate func submitWorkout() {
        Client.submitWorkout(workoutId: workoutId ?? "") { (error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension TrainingVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.gc_dequeueReusableCell(type: TrainingTableViewCell.self) else { return UITableViewCell() }
        let exersiceInfo = self.exercises[indexPath.row]
        
        cell.exercisesNameLabel.text    = exersiceInfo.name
        cell.weightLabel.text           = "\(exersiceInfo.weight ?? 0)"
        cell.setsLabel.text             = "\(exersiceInfo.times ?? 0)" + "x" + "\(exersiceInfo.count ?? 0)"
        return cell
    }
}

extension TrainingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.exercises.remove(at: indexPath.row)
        self.completedCount += 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            self.exercises.remove(at: indexPath.row)
        //
        //            if self.exercises.count == 0 {
        //                submitWorkout()
        //            }
        //
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        } else if editingStyle == .insert {
        //
        //        }
    }
}
