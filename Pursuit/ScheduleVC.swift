//
//  ScheduleVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ScheduleVC: UIViewController {
    
    fileprivate struct Constants {
        struct Dates {
            static let StartDate    = "2017 01 01"
            static let EndDate      = "2022 12 31"
        }
        struct Cell {
            let nibName: String
            let identifier: String
            
            static let schedule = Cell(nibName: "ScheduleCell", identifier: "scheduleCell")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
            
            let cell    = Constants.Cell.schedule
            let nib     = UINib(nibName: cell.nibName, bundle: .main)
            collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet{
            self.calendarView.minimumInteritemSpacing   = 0
            self.calendarView.minimumLineSpacing        = 0
            
            self.calendarView.scrollingMode             = .stopAtEachCalendarFrameWidth
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        }
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarViewVisibleDates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewVisibleDates()
        setUpBackgroundImage()
        //TODO: this thing is unnecessary, need to think how to change it. Do it with me.
        navigationController?.navigationBar.setAppearence()
    }
    
    //MARK: Override
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Private
    
    private func calendarViewVisibleDates() {
        calendarView.visibleDates { (visibleDates) in
            if let date = visibleDates.monthDates.first?.date {
                let formatter                   = DateFormatters.monthYearFormat
                self.navigationItem.leftTitle   = formatter.string(from: date)
            }
        }
    }
}

extension ScheduleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellInfo = Constants.Cell.schedule
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellInfo.identifier, for: indexPath) as? ScheduleCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension ScheduleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
}

extension ScheduleVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        return configurationParameters()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        
        cell.dateLabel.text = cellState.text
        let formatter       = DateFormatters.projectFormatFormatter
        
        cellState.handleCellTextColor(cell: cell)
        cellState.handleCellSelection(cell: cell)
        cellState.handleSpecialDates(cell: cell, specialDates: specialDates(), formatter: formatter)
        
        return cell
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        cellState.handleCellTextColor(cell: calCell)
        cellState.handleCellSelection(cell: calCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        cellState.handleCellTextColor(cell: calCell)
        cellState.handleCellSelection(cell: calCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard  let date = visibleDates.monthDates.first?.date else { return }
        let formatter = DateFormatters.monthYearFormat
        
        self.navigationItem.leftTitle = formatter.string(from: date)
    }  
}

private extension ScheduleVC {
    
    func configurationParameters() -> ConfigurationParameters {
        let formatter       = DateFormatters.projectFormatFormatter
        let start           = formatter.date(from: Constants.Dates.StartDate)!
        let end             = formatter.date(from: Constants.Dates.EndDate)!
        
        let params          = ConfigurationParameters(startDate: start, endDate: end)
        return params
    }
    
    func specialDates() -> [String:String] {
        return [
             "2017 08 01": "",
             "2017 08 08": "",
             "2017 08 14": "",
             "2017 08 24": ""
        ]
    }
}
