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
    
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var dayDigitLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
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
            
            guard let dayCur  = self.workout?.currentWorkDay else { return }
            guard let dateS = dateformatter.date(from: dayCur) else { return }
           
            dateformatter.dateFormat = "EEEE"
            let dayOfWeak: String = dateformatter.string(from: dateS)
            dateformatter.dateFormat = "MMMM yyyy"
            let monthYear: String = dateformatter.string(from: dateS)
            dateformatter.dateFormat = "dd"
            let digitOfDay: String = dateformatter.string(from: dateS)
            
            self.dayNameLabel.text = dayOfWeak
            self.dayDigitLabel.text = digitOfDay
            self.monthYearLabel.text = monthYear
            
        }
    }
    
    var exercises: [Template.Exercises] = [] {
        didSet {
            self.trainingTableView.reloadData()
        }
    }

    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    private func getWorkoutById() {
        Workout.getWorkoutById(workoutId: workoutId ?? "") { (workout, error) in
            if error == nil {
                if let workoutUn = workout {
                    self.workout = workoutUn
                    self.exercises = workoutUn.template?.exercises ?? []
                }
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
        
    }
}
