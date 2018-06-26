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
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            let cell    = Constants.Cell.schedule
            let nib     = UINib(nibName: cell.nibName, bundle: .main)
            collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet{
            self.calendarView.minimumInteritemSpacing   = 2
            self.calendarView.minimumLineSpacing        = 0
            //self.calendarView.cellSize = (calendarView.frame.size.height / 5)
            calendarView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            self.calendarView.scrollingMode             = .stopAtEachCalendarFrame
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        }
    }
    
    //MARK: Variables
    
    weak var datasource: ClientScheduleDataSource?
    
    weak var delegate: ScheduleVCDelegate?
    
    lazy var formatter       = DateFormatters.serverTimeFormatter
    
    lazy var hoursFormatter  = DateFormatters.serverHoursFormatter
    
    lazy var monthYearFormatter = DateFormatters.monthYearFormat
    
    var events: [Event] = [] {
        didSet {
            for event in self.events {
                if let date = event.date {
                    specialDates.append(date)
                }
            }
        }
    }
    
    var filteredEvents: [Event] = [] {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var specialDates: [String] = []
    
    var savedTemplatesCoordinator: SavedTemplatesCoordinator = SavedTemplatesCoordinator()
    
    @IBAction func addEventButtonPressed(_ sender: Any) {
        if let controller = UIStoryboard.trainer.ScheduleClient {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
    }
    
    @IBAction func todayDateBarButtonPressed(_ sender: Any) {
        self.calendarView.scrollToDate(Date())
        self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSideMenuController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewVisibleDates()
    
        configureNavigation()
        
        configureTabBar()
        
        updateEvents()
    }
    
    //MARK: Override
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Private
    
    private func configureNavigation() {
        navigationController?.navigationBar.setAppearence()
        
        if User.shared.coordinator is ClientCoordinator {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func configureTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureSideMenuController() {
        if self.revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    private func calendarViewVisibleDates() {
        calendarView.visibleDates { (visibleDates) in
            if let date = visibleDates.monthDates.first?.date {
               //self.updateLeftTitleWith(date)
            }
        }
    }
    
    private func updateLeftTitleWith(_ date: Date) {
        self.navigationItem.leftTitle   = self.monthYearFormatter.string(from: date)
    }
    
    private func updateEvents() {
        var changedDate = DateInRegion(absoluteDate: Date())
        let dateformatter = DateFormatters.serverTimeFormatter
        dateformatter.dateFormat = "yyyy-MM-dd"
        dateformatter.timeZone = TimeZone(identifier: "UTC")
        let startDate: String = dateformatter.string(from: changedDate.absoluteDate)
        changedDate = changedDate + 1.month
        let endDate: String = dateformatter.string(from: changedDate.absoluteDate)
        
        self.datasource?.updateDataSource(self, startDate, endDate: endDate, complation: { (events, error) in
            if error == nil {
                if let events = events {
                    self.events = events
                    self.calendarView.scrollToDate(Date(), triggerScrollToDateDelegate:true , animateScroll: true, preferredScrollPosition: .centeredHorizontally, extraAddedOffset: 0, completionHandler: {
                        self.calendarView.reloadData()
                        self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
                        self.filteredEvents = self.events.filter{ $0.date?.contains(dateformatter.string(from: Date())) ?? false }
                        self.updateLeftTitleWith(Date())
                    })
                }
            }
        })
    }
    
    func colorForRow(_ row: Int) -> UIColor {
        switch row % 3{
        case 0:
            return UIColor.eventRed()
        case 1:
            return UIColor.eventOrange()
        case 2:
            return UIColor.eventBlue()
        default:
            return UIColor.eventRed()
        }
    }
    
    func showSavedTemplates() {
        self.savedTemplatesCoordinator.start(from: self)
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

        hoursFormatter.dateFormat = "HH:mm"

        let start = hoursFormatter.date(from: iventInfo.startAt ?? "")
        let end = hoursFormatter.date(from: iventInfo.endAt ?? "")
        hoursFormatter.dateFormat = "h:mm a"

        let eventStart = hoursFormatter.string(from: start ?? Date())
        let eventEnd  = hoursFormatter.string(from: end ?? Date())
        cell.dateLabel.text         = eventStart + "-" + eventEnd
        cell.eventTitle.text        =  iventInfo.title ?? ""
        cell.clientsCountLabel.text = "\(iventInfo.clients?.count ?? 0)"
        cell.categoryView.backgroundColor = colorForRow(indexPath.row)
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
        cellState.handleCellTextColor(cell: cell)
        cellState.handleCellSelection(cell: cell)
        cellState.handleSpecialDates(cell: cell, specialDates: specialDates)
        
        return cell
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        cellState.handleCellTextColor(cell: calCell)
        cellState.handleCellSelection(cell: calCell)
        cellState.handleSpecialDates(cell: calCell, specialDates: specialDates)
        self.filteredEvents = self.events.filter{ $0.date?.contains(formatter.string(from: cellState.date)) ?? false }
        updateLeftTitleWith(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        cellState.handleCellTextColor(cell: calCell)
        cellState.handleCellSelection(cell: calCell)
        cellState.handleSpecialDates(cell: calCell, specialDates: specialDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard  let date = visibleDates.monthDates.first?.date else { return }
        updateLeftTitleWith(date)
    }
}

private extension ScheduleVC {
    
    func configurationParameters() -> ConfigurationParameters {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let formatter       = DateFormatters.projectFormatFormatter
        formatter.timeZone  = TimeZone(identifier: "UTC")
        let start           = formatter.date(from: Constants.Dates.StartDate)!
        let end             = formatter.date(from: Constants.Dates.EndDate)!
        
        let params          = ConfigurationParameters(startDate: start, endDate: end, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow)
        return params
    }
}
