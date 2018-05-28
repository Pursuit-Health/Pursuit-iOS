//
//  CreateTemplateVC.swift
//  Pursuit
//
//  Created by Igor on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit


import SwipeCellKit

protocol CreateTemplateVCDelegate: class {
    
    func saveWorkout(_ workout: Workout, on controller: CreateTemplateVC)
    func addExercisesButtonPressed(on controller: CreateTemplateVC)
    func exerciseSelected(exercise: ExcersiseData, on controller: CreateTemplateVC)
    func editWorkout(_ workout: Workout, on controller: CreateTemplateVC)
    func deleteWorkoutExercise(_ workout: Workout, exercise: ExcersiseData, on controller: CreateTemplateVC)
    func closeBarButtonPressed(on controller: CreateTemplateVC)
}

extension CreateTemplateVCDelegate {
    func editWorkout(_ workout: Workout, on controller: CreateTemplateVC) {}
    func addExercisesButtonPressed(on controller: CreateTemplateVC) {}
    func deleteWorkoutExercise(_ workout: Workout, exercise: ExcersiseData, on controller: CreateTemplateVC){}
}

class CreateTemplateVC: UIViewController {
    
    //MARK: Enum
    
    enum Cell {
        case header(name: String)
        case excersise(excersise: ExcersiseData, delegate: SwipeTableViewCellDelegate)
        
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
            case .excersise(let excersise, let delegate):
                if let cell = cell as? TrainingTableViewCell {
                    self.fillExcersise(cell: cell, with: excersise, delegate: delegate)
                }
            }
        }
        
        func fillExcersise(cell: TrainingTableViewCell, with excersise: ExcersiseData, delegate: SwipeTableViewCellDelegate) {
            let weightsType = UserSettings.shared.weightsType
            var weight = Double(excersise.weight ?? 0)
            var reps = excersise.reps ?? 0
            cell.exercisesNameLabel.text    = excersise.name
            if excersise.sets?.first?.reps_min == 10000 {
                weight = Double(excersise.sets?.first?.weight_max ?? 0)
                reps = excersise.sets?.first?.reps_max ?? 0
            }
            cell.weightLabel.text           = weightsType.getWeightsFrom(weight: weight)
            cell.setsLabel.text             = "\(excersise.sets_count ?? 0)" + "x" + "\(reps) reps"
            cell.completedExImageView.isHidden = !(excersise.isDone ?? false)
            if User.shared.type == .trainer{ 
                cell.delegate = delegate
            }
        }
        
        func fillHeader(cell: HeaderCell, with name: String) {
            cell.headerView.sectionNameLabel.text = name.uppercased()
        }
    }
    
    //MARK: Constants
    
     struct Constants {
        struct Dates {
            static let StartDate    = "2017 01 01"
            static let EndDate      = "2022 12 31"
        }
        struct Cell {
            let nibName: String
            let identifier: String
            
            static let TemplateCalendar = Cell(nibName: "CreateTemplateCalendarCell", identifier: "CreateTemplateCalendarCellReuseID")
        }
    }
    
    @IBOutlet weak var templateTableView: UITableView! {
        didSet {
            templateTableView.rowHeight             = UITableViewAutomaticDimension
            templateTableView.estimatedRowHeight    = 200
            templateTableView.ept.dataSource        = self
        }
    }
    
    @IBOutlet weak var templateNameTextField: UITextField! {
        didSet {
            self.templateNameTextField.attributedPlaceholder =  NSAttributedString(string: "Template Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
    }
    
    @IBOutlet weak var notesTextField: UITextField! {
        didSet {
            self.notesTextField.attributedPlaceholder =  NSAttributedString(string: "Notes", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        }
    }
    
   
    
    @IBOutlet weak var calendarContainerView: UIView!
    
    //MARK: Variables
    

    weak var delegate: CreateTemplateVCDelegate?
    
    var exercises: [ExcersiseData] {
        return workoutNew?.excersises ?? []
    }
    
    var workout = Workout()
    
    var exerciseTypes: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
    
    var workoutNew: Workout? {
        didSet {
            self.recalculate()
        }
    }
    
    var sections: [Int : [Cell]] = [:] {
        didSet {
            self.templateTableView?.reloadData()
        }
    }
    
    var isDone: Bool? {
        return self.workoutNew?.isDone
    }
    
    var shouldClear: Bool = true
    
    var isEditTemplate: Bool = false
    
    //MARK: IBActions
    
    @IBAction func addExercisesButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        addExerciseButtonPressed()
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        closeButtonPressed()
    }
    
    @IBAction func saveTemplateButtonPressed(_ sender: Any) {
        saveTemplate()
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setAppearence()
        self.tabBarController?.tabBar.isHidden = true
        //TODO: Reimplament

        self.updateUI()

        self.recalculate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.workoutNew?.notes = self.notesTextField.text
    }
    
    //MARK: Public.Methods
    
    func updateUI() {

    }
    
    func saveTemplate() {
        
    }
    
    func recalculate() {
        
    }
    
    func addExerciseButtonPressed() {
        self.delegate?.addExercisesButtonPressed(on: self)
    }
    
    func closeButtonPressed() {
        self.delegate?.closeBarButtonPressed(on: self)
    }
    
    
    func recalculateRows() {
        var section = 0
        var sections: [Int : [Cell]] = [:]
        var warmups = self.exercises.filter{ $0.type == .warmup }.map{ Cell.excersise(excersise: $0, delegate: self) }
        var workouts = self.exercises.filter{ $0.type == .workout }.map{ Cell.excersise(excersise: $0, delegate: self) }
        var cooldowns = self.exercises.filter{ $0.type == .cooldown }.map{ Cell.excersise(excersise: $0, delegate: self) }
        
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
    
    func updateTemplate(client: Client?) {
        self.workoutNew?.getDetailedTemplateFor(clientId: "\(client?.id ?? 0)", templateId: "\(workoutNew?.id ?? 0)") { (exercises, error) in
            if error == nil {
                self.updateUI()
                self.recalculate()
            }
        }
    }
    

    //MARK: Private
    
     func showAlert() {
        let alert = UIAlertController(title: "Please enter Template name.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateTemplateVC {
    func loadTemplate() {
        
    }
    
    private func loadTemplateById(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        Template.getTemplateWithExercises(templateId: "", completion: { template, error in
            
            completion(error)
        })
    }
}

extension CreateTemplateVC: UITableViewDataSource{
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

extension CreateTemplateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie, _) = cellInfo {
            
            self.delegate?.exerciseSelected(exercise: excersie, on: self)
            
        }
        //        if let controller = exercisesDetailsVC {
        //            let exersiceInfo = self.exercises[indexPath.row - 1]
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return UITableViewAutomaticDimension
    }
    
}

extension CreateTemplateVC: AddExerceiseVCDelegate {
    func customexerciseAdded(exercise: ExcersiseData, on controller: AddExerceiseVC) {
        
    }
    
    func saveExercises(_ exercise: Template.Exercises, on controller: AddExerceiseVC) {
        
    }
}

extension CreateTemplateVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie, _) = cellInfo {
                
                if let workout = self.workoutNew {
                    if excersie.id == nil {
                        for (index, exe) in (self.workoutNew?.excersises?.enumerated())! {
                            if exe === excersie {
                                self.workoutNew?.excersises?.remove(at: index)
                            }
                        }
                        self.recalculate()
                    }else {
                        self.delegate?.deleteWorkoutExercise(workout, exercise: excersie, on: self)
                    }
            }
        }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.transitionStyle = .border //or drag/reveal/border
        options.expansionStyle = .none
        options.buttonPadding = 0
        
        return options
    }
}

extension CreateTemplateVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "Press the + to add exercises"
    }
    
    var emptyImageName: String {
        return  ""
    }
    
    var fontSize: CGFloat {
        return 25.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}

