//
//  CreateTemplateVC.swift
//  Pursuit
//
//  Created by ігор on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate

protocol CreateTemplateVCDelegate: class {
    
    func saveWorkout(_ workout: Workout, on controller: CreateTemplateVC)
    func addExercisesButtonPressed(on controller: CreateTemplateVC)
    func exerciseSelected(exercise: ExcersiseData, on controller: CreateTemplateVC)
    func editWorkout(_ workout: Workout, on controller: CreateTemplateVC)
}

extension CreateTemplateVCDelegate {
    func editWorkout(_ workout: Workout, on controller: CreateTemplateVC) {}
}

extension CreateTemplateVCDelegate {
    func addExercisesButtonPressed(on controller: CreateTemplateVC) {}
}

class CreateTemplateVC: UIViewController {
    
    //MARK: Enum
    
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
    
    //MARK: Constants
    
    fileprivate struct Constants {
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
    
    //MARK: IBOutlets
    
    //MARK: CalendarView
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet{
            let cellData    = Constants.Cell.TemplateCalendar
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            self.calendarView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
            
            self.calendarView.minimumInteritemSpacing   = 0
            self.calendarView.minimumLineSpacing        = 0
            
            self.calendarView.scrollingMode             = .stopAtEachCalendarFrame
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            let formatter       = DateFormatters.serverTimeFormatter
            formatter.timeZone = TimeZone(identifier: "UTC")
            self.startAt = formatter.string(from: Date())
        }
    }
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var templateTableView: UITableView! {
        didSet {
            templateTableView.rowHeight             = UITableViewAutomaticDimension
            templateTableView.estimatedRowHeight    = 200
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
    
    @IBOutlet weak var addworkoutButton: UIBarButtonItem!
    //MARK: Variables
    
    weak var delegate: CreateTemplateVCDelegate?

    var exercises: [ExcersiseData] {
      return workoutNew?.excersises ?? []
    }
    
    var workout = Workout()
    
    var startAt: String? {
        didSet {
            self.workout.startAtForUpload  = self.startAt
        }
    }

    var chnagedDate = DateInRegion(absoluteDate: Date())
    
    var exerciseTypes: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
    
    var dateformatter = DateFormatters.serverTimeFormatter
    
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
        self.delegate?.addExercisesButtonPressed(on: self)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTemplateButtonPressed(_ sender: Any) {
        //TODO: Reimplament
        if templateNameTextField.text == "" {
            showAlert()
            return
        }

        self.workout.name               = self.templateNameTextField.text
        self.workout.notes              = self.notesTextField.text
        
        if let done = isDone {
            if !done {
                self.workout = self.workoutNew!
                self.workout.name               = self.templateNameTextField.text
                self.workout.notes              = self.notesTextField.text
                self.workout.startAtForUpload   = nil
                self.workout.excersises         = self.exercises
                delegate?.editWorkout(self.workout, on: self)
            }
        }else {
            self.workout.excersises         = self.exercises
            self.workout.startAtForUpload   = self.startAt
            delegate?.saveWorkout(self.workout, on: self)
        }
    }
    
    
    @IBAction func increaseButtonPressed(_ sender: Any) {
        decreaseDate(false)
    }
    
    @IBAction func decreaseDateButtonPressed(_ sender: Any) {
        decreaseDate(true)
    }
    
    private func decreaseDate(_ decrease: Bool?) {
         if let done = isDone {
            if !done {
               return
            }
        }
        if let decrease = decrease {
            if decrease {
                chnagedDate = chnagedDate - 1.month
            }else {
                chnagedDate = chnagedDate + 1.month            }
            self.calendarView.scrollToDate(chnagedDate.absoluteDate)
        }
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        decreaseDate(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setAppearence()
        self.tabBarController?.tabBar.isHidden = true
        //TODO: Reimplament
         if !shouldClear {
            self.templateNameTextField.text = workoutNew?.name ?? ""
            self.notesTextField.text = workoutNew?.notes ?? ""
        }
        
        if let done = isDone {
        if done {
            self.addworkoutButton.isEnabled = false
            self.templateNameTextField.isUserInteractionEnabled = false
            self.calendarView.isUserInteractionEnabled = false
            self.templateTableView.allowsSelection = false
        }else {
            self.calendarView.isUserInteractionEnabled = false
            self.addworkoutButton.isEnabled = true
            }
        }else {
           self.calendarView.isUserInteractionEnabled = true
        }
        
        if let start = workoutNew?.startAt {
            let date = Date(timeIntervalSince1970: start)
          self.calendarView.scrollToDate(date)
            self.calendarView.selectDates([date], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        }

        calendarView.visibleDates { (visibleDates) in
            if let date = visibleDates.monthDates.first?.date {
                let formatter       = DateFormatters.serverTimeFormatter
                formatter.timeZone = TimeZone(identifier: "UTC")
                self.fillMonthYearLabelsWith(date)
            }
        }
        
        self.recalculate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.workoutNew?.notes = self.notesTextField.text
    }
    
    //MARK: Public.Methods
    
    func recalculate() {
        self.recalculateRows()
    }
    
    //MARK: Private.Methods
    
    private func recalculateRows() {
        var section = 0
        var sections: [Int : [Cell]] = [:]
        var warmups = self.exercises.filter{ $0.type == .warmup }.map{ Cell.excersise(excersise: $0) }
        var workouts = self.exercises.filter{ $0.type == .workout }.map{ Cell.excersise(excersise: $0) }
        var cooldowns = self.exercises.filter{ $0.type == .cooldown }.map{ Cell.excersise(excersise: $0) }
        
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
    
    func fillMonthYearLabelsWith(_ date: Date) {
        let formatter                   = DateFormatters.monthYearFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        let textToSee = formatter.string(from: date)
        let subText = textToSee.components(separatedBy: " ")
        self.monthLabel.text = subText[0]
        self.yearLabel.text = subText[1]
    }
    //MARK: Private
    
    private func showAlert() {
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
        
        if let cellInfo = self.sections[indexPath.section]?[indexPath.row], case .excersise(let excersie) = cellInfo {

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

extension CreateTemplateVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let formatter       = DateFormatters.serverTimeFormatter
        formatter.timeZone  = TimeZone(identifier: "UTC")
        
        let start           = formatter.date(from: "2017-01-01")!
        let end             = formatter.date(from: "2022-01-01")!
        let parameters = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 1, calendar: calendar)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.Cell.TemplateCalendar.identifier, for: indexPath) as? CreateTemplateCalendarCell else { return JTAppleCell() }
        
        cell.monthDayLabel.text = cellState.text
        cell.weekDayLabel.text =  cellState.date.dayOfWeek()

        cellState.templateCalendarCellselected(cell: cell)
        return cell
    }
}

extension CreateTemplateVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CreateTemplateCalendarCell else { return }
        let formatter       = DateFormatters.serverTimeFormatter
        formatter.timeZone = TimeZone(identifier: "UTC")
        self.startAt = formatter.string(from: date)
        
        cellState.templateCalendarCellselected(cell: calCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CreateTemplateCalendarCell else { return }

        cellState.templateCalendarCellselected(cell: calCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard  let date = visibleDates.monthDates.first?.date else { return }
        self.chnagedDate = DateInRegion(absoluteDate: date)
        self.fillMonthYearLabelsWith(date)
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return String(dateFormatter.string(from: self).capitalized.prefix(3))
    }
}
