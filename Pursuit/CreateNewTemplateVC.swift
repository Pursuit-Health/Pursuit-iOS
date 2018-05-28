//
//  CreateNewTemplateVC.swift
//  Pursuit
//
//  Created by Igor on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwiftDate
import JTAppleCalendar

class CreateNewTemplateVC: CreateTemplateVC {
    
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
    
    @IBOutlet weak var increaseDateButton: UIButton!
    @IBOutlet weak var decreaseDateButton: UIButton!
    
    @IBOutlet weak var addworkoutButton: UIBarButtonItem!
    @IBOutlet weak var bottomViewWithButton: UIView!
    
    //MARK: Variables
    
    override var exercises: [ExcersiseData] {
        return workoutNew?.excersises ?? []
    }
    
    var startAt: String? {
        didSet {
            self.workout.startAtForUpload  = self.startAt
        }
    }
    
     var dateformatter = DateFormatters.serverTimeFormatter
    
     var chnagedDate = DateInRegion(absoluteDate: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
         decreaseDate(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let start = workoutNew?.startAt {
            let date = Date(timeIntervalSince1970: start)
            self.calendarView?.scrollToDate(date)
            self.calendarView?.selectDates([date], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        }
        
        calendarView?.visibleDates { (visibleDates) in
            if let date = visibleDates.monthDates.first?.date {
                let formatter       = DateFormatters.serverTimeFormatter
                formatter.timeZone = TimeZone(identifier: "UTC")
                self.fillMonthYearLabelsWith(date)
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func increaseButtonPressed(_ sender: Any) {
        decreaseDate(false)
    }
    
    @IBAction func decreaseDateButtonPressed(_ sender: Any) {
        decreaseDate(true)
    }
    
    //MARK: Private
    
    //MARK: Private.Methods
    
    private func decreaseDate(_ decrease: Bool?) {
        if let decrease = decrease {
            if decrease {
                chnagedDate = chnagedDate - 1.month
            }else {
                chnagedDate = chnagedDate + 1.month            }
            self.calendarView.scrollToDate(chnagedDate.absoluteDate)
        }
    }
    
    override func recalculate() {
        self.recalculateRows()
    }
    
    override func saveTemplate() {
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
    
    override func updateUI() {
        if !shouldClear {
            self.templateNameTextField.text = workoutNew?.name ?? ""
            self.notesTextField.text = workoutNew?.notes ?? ""
        }
        
        if let done = isDone {
            if done {
                self.leftTitle = "Completed Template"
                self.addworkoutButton.isEnabled = false
                self.templateNameTextField.isUserInteractionEnabled = false
                self.calendarView.isUserInteractionEnabled = false
                //self.templateTableView.allowsSelection = false
                self.bottomViewWithButton.isHidden = true
                self.notesTextField.isUserInteractionEnabled = false
            }else {
                self.calendarView.isUserInteractionEnabled = false
                self.addworkoutButton.isEnabled = true
                self.leftTitle = workoutNew?.name ?? ""
                self.bottomViewWithButton.isHidden = false
            }
            increaseDateButton?.isEnabled = false
            decreaseDateButton?.isEnabled = false
        }else {
            self.calendarView?.isUserInteractionEnabled = true
            increaseDateButton?.isEnabled = true
            decreaseDateButton?.isEnabled = true
        }
    }
    
    func fillMonthYearLabelsWith(_ date: Date) {
        let formatter                   = DateFormatters.monthYearFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        let textToSee = formatter.string(from: date)
        let subText = textToSee.components(separatedBy: " ")
        self.monthLabel.text = subText[0]
        self.yearLabel.text = subText[1]
    }
}

extension CreateNewTemplateVC: JTAppleCalendarViewDataSource {
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

extension CreateNewTemplateVC: JTAppleCalendarViewDelegate {
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
