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
    func saveTemplate(_ template: Template, on controllers: CreateTemplateVC)
    func addExercisesButtonPressed(on controller: CreateTemplateVC)
}

extension CreateTemplateVCDelegate {
    func addExercisesButtonPressed(on controller: CreateTemplateVC) {}
}

class CreateTemplateVC: UIViewController {
    
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
            if self.templateId == nil {
                self.templateNameTextField.text = ""
            }
        }
    }
    
    //MARK: Variables
    
    weak var delegate: CreateTemplateVCDelegate?
    
    lazy var exercisesDetailsVC: ExerciseDetailsVC? = {
        guard let controller = UIStoryboard.trainer.ExerciseDetails else {  return UIViewController() as? ExerciseDetailsVC }
        
        return controller
        
    }()
    
    var templateId: String? {
        didSet {
            loadTemplate()
        }
    }
    
    var template: Template? {
        didSet {
            guard let name = self.template?.name else { return }
            self.templateNameTextField.text = name
        }
    }
    
    var exercises: [Template.Exercises] = [] {
        didSet {
            self.templateTableView?.reloadData()
        }
    }
    
    lazy var addExercisesVC: AddExerceiseVC? = {
        
        guard let controller = UIStoryboard.trainer.AddExercises else { return UIViewController() as? AddExerceiseVC }
        
        controller.delegate = self
        
        return controller
    }()
    
    lazy var mainExercisesVC: MainExercisesVC? = {
        guard let controller = UIStoryboard.trainer.MainExercises else { return UIViewController() as? MainExercisesVC }

        return controller
    }()
    
    var chnagedDate = DateInRegion(absoluteDate: Date())
    
    var exerciseTypes: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
    
    //MARK: IBActions
    
    @IBAction func addExercisesButtonPressed(_ sender: Any) {
        
        self.delegate?.addExercisesButtonPressed(on: self)
        //guard let controller = mainExercisesVC else { return }
        
        //self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTemplateButtonPressed(_ sender: Any) {
        if templateNameTextField.text == "" {
            showAlert()
            return
        }
        let template = Template()
        
        template.name = self.templateNameTextField.text
        template.imageId = 1
        template.time = 60
        template.exercisesForUpload = exercises
        if let newExercises = template.exercisesForUpload {
            if newExercises.count > 0 {
                for index in 0...newExercises.count - 1 {
                    template.exercisesForUpload?[index].exerciseId = nil
                }
            }
        }
        delegate?.saveTemplate(template, on: self)
    }
    
    
    @IBAction func increaseButtonPressed(_ sender: Any) {
        decreaseDate(false)
    }
    
    @IBAction func decreaseDateButtonPressed(_ sender: Any) {
        decreaseDate(true)
    }
    
    private func decreaseDate(_ decrease: Bool?) {
        
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
        if self.templateId == nil {
            self.templateNameTextField.text = ""
        }
        
        calendarView.visibleDates { (visibleDates) in
            if let date = visibleDates.monthDates.first?.date {
                self.fillMonthYearLabelsWith(date)
            }
        }
    }
    
    func fillMonthYearLabelsWith(_ date: Date) {
        let formatter                   = DateFormatters.monthYearFormat
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
        if templateId != nil {
            loadTemplateById{ error in
                if error == nil {
                    
                }else {
                }
            }
        }else {
            self.template = nil
            self.exercises = []
        }
    }
    
    private func loadTemplateById(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        Template.getTemplateWithExercises(templateId: templateId ?? "", completion: { template, error in
            if let templateInfo = template {
                self.template = templateInfo
                if let exercise  = templateInfo.exercises {
                    self.exercises = exercise
                }
            }
            completion(error)
        })
    }
}

extension CreateTemplateVC: UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TrainingTableViewCell.self) else { return UITableViewCell()
        }
        if indexPath.row == 0 {
            guard let headercell = tableView.gc_dequeueReusableCell(type: HeaderCell.self) else { return UITableViewCell() }
            let headerView = HeaderView()
            headerView.sectionNameLabel.text = exerciseTypes[indexPath.section].name.uppercased()
            headercell.contentView.addSubview(headerView)
            headercell.contentView.addConstraints(UIView.place(headerView, onOtherView: headercell.contentView))
            return headercell
        }
        
        let exersiceInfo = self.exercises[indexPath.row - 1]
        
        cell.exercisesNameLabel.text    = exersiceInfo.name
        cell.weightLabel.text           = "\(exersiceInfo.weight ?? 0)"
        cell.setsLabel.text             = "\(exersiceInfo.times ?? 0)" + "x" + "\(exersiceInfo.count ?? 0)"
        
        return cell
    }
}

extension CreateTemplateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = exercisesDetailsVC {
            let exersiceInfo = self.exercises[indexPath.row - 1]
            self.navigationController?.pushViewController(controller, animated: true)
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

extension CreateTemplateVC: AddExerceiseVCDelegate {
    func saveExercises(_ exercise: Template.Exercises, on controller: AddExerceiseVC) {
        let exercise = self.exercises + [exercise]
        self.exercises = exercise
        
    }
}

extension CreateTemplateVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter       = DateFormatters.projectFormatFormatter
        let start           = formatter.date(from: "2017 01 01")!
        let end             = formatter.date(from: "2018 01 01")!
        let parameters = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 1, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: nil, hasStrictBoundaries: nil)
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
