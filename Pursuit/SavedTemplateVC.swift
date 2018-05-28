//
//  SavedTemplateVC.swift
//  Pursuit
//
//  Created by Igor on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol SavedTemplateVCDelegate: class {
    func saveTemplate(_ template: SavedTemplateModel, on controller: SavedTemplateVC)
    func addExercisesButtonPressed(on controller: SavedTemplateVC)
    func exerciseSelected(exercise: ExcersiseData, on controller: SavedTemplateVC)
    func editTemplate(_ template: SavedTemplateModel, on controller: SavedTemplateVC)
    func deleteTemplateExercise(_ template: SavedTemplateModel, exercise: ExcersiseData, on controller: SavedTemplateVC)
    func closeBarButtonPressed(on controller: SavedTemplateVC)
}

class SavedTemplateVC: UIViewController {
    
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
            let weight = Double(excersise.weight ?? 0)
            cell.exercisesNameLabel.text    = excersise.name
            cell.weightLabel.text           = weightsType.getWeightsFrom(weight: weight)
            cell.setsLabel.text             = "\(excersise.reps ?? 0)" + "x" + "\(excersise.sets_count ?? 0) reps"
            cell.completedExImageView.isHidden = !(excersise.isDone ?? false)
            if User.shared.type == .trainer{
                cell.delegate = delegate
            }
        }
        
        func fillHeader(cell: HeaderCell, with name: String) {
            cell.headerView.sectionNameLabel.text = name.uppercased()
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
            self.templateNameTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    self.savedTemplate?.name = text
                }
            }
        }
    }
    
    @IBOutlet weak var notesTextField: UITextField! {
        didSet {
            self.notesTextField.attributedPlaceholder =  NSAttributedString(string: "Notes", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
            self.notesTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    self.savedTemplate?.notes = text
                }
            }
        }
    }
    
    
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

    weak var delegate: SavedTemplateVCDelegate?
    
    var sections: [Int : [Cell]] = [:] {
        didSet {
            self.templateTableView?.reloadData()
        }
    }
    
    var exerciseTypes: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
    
    var savedTemplate: SavedTemplateModel? = SavedTemplateModel() {
        didSet {
            self.recalculate()
        }
    }
    
    var exercises: [ExcersiseData] {
       return savedTemplate?.exercises ?? []
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setAppearence()
        
        self.updateUI()
        self.recalculate()
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
    
    func updateUI() {
        self.templateNameTextField.text =   self.savedTemplate?.name ?? ""
        self.notesTextField.text =          self.savedTemplate?.notes ?? ""
    }
    
     func recalculate() {
        self.recalculateRows()
    }
    
     func addExerciseButtonPressed() {
        self.delegate?.addExercisesButtonPressed(on: self)
    }
    
     func closeButtonPressed() {
        self.delegate?.closeBarButtonPressed(on: self)
    }
    
    func saveTemplate() {
        let template = SavedTemplateModel()
        template.name       = self.templateNameTextField.text ?? ""
        template.notes      = self.notesTextField.text ?? ""
        template.exercises  = self.exercises
        template.id         = savedTemplate?.id
        savedTemplate       = template
        guard let savedtemplate = savedTemplate else { return }
        
        if savedtemplate.id == nil {
            self.delegate?.saveTemplate(savedtemplate, on: self)
        }else {
            self.delegate?.editTemplate(savedtemplate, on: self)
        }
    }
    //MARK: Private.Methods
}

extension SavedTemplateVC: UITableViewDataSource {
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

extension SavedTemplateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie, _) = cellInfo {
            self.delegate?.exerciseSelected(exercise: excersie, on: self)
        }
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

extension SavedTemplateVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie, _) = cellInfo {
                
                if let template = self.savedTemplate, let exercises = template.exercises {
                    if excersie.id == nil {
                        for (index, exe) in exercises.enumerated() {
                            if exe === excersie {
                                self.savedTemplate?.exercises?.remove(at: index)
                            }
                        }
                        self.recalculate()
                    }else {
                        self.delegate?.deleteTemplateExercise(template, exercise: excersie, on: self)
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

extension SavedTemplateVC: PSEmptyDatasource {
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
