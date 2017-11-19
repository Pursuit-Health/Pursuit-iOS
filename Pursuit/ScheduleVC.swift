//
//  ScheduleVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SDWebImage
import SwiftDate

typealias EventsCompletion = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void

protocol ClientScheduleDataSource: class {
    func updateDataSource(_ schedule: ScheduleVC, _ startDate: String, endDate: String, complation: @escaping EventsCompletion)
}

protocol ScheduleVCDelegate: class {
    func removeAuthController(on controller: ScheduleVC)
    func menuButtonPressed(on controller: ScheduleVC)
}

extension ScheduleVCDelegate{
    func menuButtonPressed(on controller: ScheduleVC) {
        
    }
}

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
    
    //MARK: Variables
    
    weak var datasource: ClientScheduleDataSource?
    
    weak var delegate: ScheduleVCDelegate?
    
    var events: [Event] = [] {
        didSet {
            self.calendarView.reloadData()
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            
     
        }
    }
    
    var filteredEvents: [Event] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
  
            //controller?.viewControllers.removeLast()
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
    }
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewVisibleDates()
        
        setUpBackgroundImage()
        
        self.tabBarController?.tabBar.isHidden = false
        //TODO: this thing is unnecessary, need to think how to change it. Do it with me.
        navigationController?.navigationBar.setAppearence()
        
        //self.navigationController?.isNavigationBarHidden = false

        updateEvents()
        
        self.delegate?.removeAuthController(on: self)
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
    
    func updateEvents() {
        var changedDate = DateInRegion(absoluteDate: Date())
        let dateformatter = DateFormatters.serverTimeFormatter
        dateformatter.dateFormat = "yyyy-MM-dd"
        let startDate: String = dateformatter.string(from: changedDate.absoluteDate)
        changedDate = changedDate + 1.month
        let endDate: String = dateformatter.string(from: changedDate.absoluteDate)
        
        self.datasource?.updateDataSource(self, startDate, endDate: endDate, complation: { (events, error) in
            if error == nil {
                if let events = events {
                    self.filteredEvents = events
                    self.events = events
                }
            }
        })
    }
}

extension ScheduleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellInfo = Constants.Cell.schedule
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellInfo.identifier, for: indexPath) as? ScheduleCell else {
            return UICollectionViewCell()
        }
        
        let iventInfo = filteredEvents[indexPath.row]
        cell.descriptionLabel.text  = iventInfo.location
        cell.dateLabel.text         = (iventInfo.startAt ?? "") + "-" + (iventInfo.endAt ?? "")
        
        cell.clientsCountLabel.text = "\(iventInfo.clients?.count ?? 0)"
        cell.fillImages(clients: iventInfo.clients ?? [])
        
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
        let formatter       = DateFormatters.serverTimeFormatter
        
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
        
        let formatter       = DateFormatters.serverTimeFormatter
        
        self.filteredEvents = self.events.filter{ $0.date?.contains(formatter.string(from: cellState.date)) ?? false }
        
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
    
    func specialDates() -> [String] {
        var specialDates: [String] = []
        for event in self.events {
            if let date = event.date {
                specialDates.append(date)
            }
        }
        return specialDates
    }
    
    func fromStringToDate(specialDates: [String]) -> [Date] {
        let formatter       = DateFormatters.serverTimeFormatter
        var dates: [Date] = []
        for date in specialDates {
            if let data = formatter.date(from: date) {
                dates.append(data)
            }
        }
        return dates
    }
}
