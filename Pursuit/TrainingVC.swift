//
//  TrainingVC.swift
//  Pursuit
//
//  Created by Igor on 8/4/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol TrainingVCDelegate: class {
    func select(excercise: ExcersiseData, on controller: TrainingVC)
}

class TrainingVC: UIViewController {
    
    enum Cell {
        case header(name: String)
        case excersise(excersise: ExcersiseData)
        
        var type: UITableViewCell.Type {
            switch self {
            case .header:
                return HeaderCell.self
            case .excersise:
                return TrainingTableViewCell.self
            }
        }
        
        func fill(cell: UITableViewCell) {
            switch self {
            case .header(let name):
                if let cell = cell as? HeaderCell {
                    self.fillHeader(cell: cell, with: name)
                }
            case .excersise(let excersise):
                if let cell = cell as? TrainingTableViewCell {
                    self.fillExcersise(cell: cell, with: excersise)
                }
            }
        }
        
        func fillExcersise(cell: TrainingTableViewCell, with excersise: ExcersiseData) {
            cell.exercisesNameLabel.text    = excersise.name
            cell.weightLabel.text           = "\(excersise.weight ?? 0) lbs"
            cell.setsLabel.text             = "\(excersise.reps ?? 0)" + "x" + "\(excersise.sets ?? 0) reps"
        }
        
        func fillHeader(cell: HeaderCell, with name: String) {
            cell.headerView.sectionNameLabel.text = name.uppercased()
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var todoLabel        : UILabel!
    @IBOutlet weak var completedLabel   : UILabel!
    @IBOutlet weak var monthYearLabel   : UILabel!
    @IBOutlet weak var dayDigitLabel    : UILabel!
    @IBOutlet weak var dayNameLabel     : UILabel!
    
    @IBOutlet weak var trainingTableView: UITableView! {
        didSet{
            trainingTableView.rowHeight             = UITableViewAutomaticDimension
            trainingTableView.estimatedRowHeight    = 200
        }
    }
    
    //MARK: Variables
    
    var exercises: [ExcersiseData] {
        return self.workout?.excersises ?? []
    }
    weak var delegate: TrainingVCDelegate?
    
    var dateformatter = DateFormatters.serverTimeFormatter
    
    var workout: Workout? {
        didSet {
            self.recalculate()
        }
    }
    
    var sections: [Int : [Cell]] = [:] {
        didSet {
            self.trainingTableView?.reloadData()
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recalculate()
        self.trainingTableView.tableHeaderView = self.headerView
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setAppearence()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Public.Methods
    
    func recalculate() {
        self.recalculateRows()
        self.recalculateTexts()
    }
    
    //MARK: Private.Methods
    
    private func recalculateTexts() {
        let done = self.exercises.filter{ $0.isDone ?? false }.count
        let todo = self.exercises.count - done
        
        let date = Date(timeIntervalSince1970: (self.workout?.startAt ?? 0))
        
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        self.dayNameLabel.text = f.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
        self.monthYearLabel.text = f.string(from: date)
        
        f.dateFormat = "dd"
        self.dayDigitLabel.text = f.string(from: date)
        
        self.completedLabel?.text    = String(done)
        self.todoLabel?.text         = String(todo)
        
        self.leftTitle = self.workout?.name
    }
    
    private func recalculateRows() {
        var section = 0
        var sections: [Int : [Cell]] = [:]
        var warmups = self.exercises.filter{ $0.type == .warmup && !($0.isDone ?? false) }.map{ Cell.excersise(excersise: $0) }
        var workouts = self.exercises.filter{ $0.type == .workout && !($0.isDone ?? false) }.map{ Cell.excersise(excersise: $0) }
        var cooldowns = self.exercises.filter{ $0.type == .cooldown && !($0.isDone ?? false) }.map{ Cell.excersise(excersise: $0) }
        
        if !warmups.isEmpty {
            warmups.insert(.header(name: ExcersiseData.ExcersiseType.warmup.name), at: 0)
            sections[section] = warmups
            section += 1
        }
        if !workouts.isEmpty {
            workouts.insert(.header(name: ExcersiseData.ExcersiseType.workout.name), at: 0)
            sections[section] = workouts
            section += 1
        }
        if !cooldowns.isEmpty {
            cooldowns.insert(.header(name: ExcersiseData.ExcersiseType.cooldown.name), at: 0)
            sections[section] = cooldowns
            section += 1
        }
        
        self.sections = sections
    }
}

extension TrainingVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellInfo = self.sections[indexPath.section]?[indexPath.row], let cell = tableView.gc_dequeueReusableCell(type: cellInfo.type) {
            cellInfo.fill(cell: cell)
            return cell
        }
        return UITableViewCell()
    }
}

extension TrainingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie) = cellInfo {
            self.delegate?.select(excercise: excersie, on: self)
        }
    }
}
