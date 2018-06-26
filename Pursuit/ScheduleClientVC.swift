//
//  ScheduleClientVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 7/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwiftDate
import JTAppleCalendar

//TODO: Same
class ScheduleClientVC: UIViewController {
    
    //MARK: Constants
    
    struct Constants {
        struct Dates {
            static let StartDate    = "2017 01 01"
            static let EndDate      = "2022 12 31"
        }
        
        struct Cell {
            var nibName: String
            var identifier: String
            
            static let client = Cell(nibName: "ScheduleClientCollectionViewCell", identifier: "ScheduleClientCollectionViewCellReuseID")
        }
        struct CalendarCell {
            let nibName: String
            let identifier: String
            
            static let TemplateCalendar = Cell(nibName: "CreateTemplateCalendarCell", identifier: "CreateTemplateCalendarCellReuseID")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var eventTitleTextField: UITextField! {
        didSet {
            eventTitleTextField.attributedPlaceholder = NSAttributedString(string: "Event Title", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
    }
    
    @IBOutlet weak var startDateTextField: UITextField! {
        didSet {
            self.startDateTextField.inputView = startDatePicker()
        }
    }
    
    @IBOutlet weak var endDateTextField: UITextField! {
        didSet {
            self.endDateTextField.inputView = endDatePicker()
        }
    }
    @IBOutlet weak var locationTextField: CustomTextField! {
        didSet {
            locationTextField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
    }
    
    @IBOutlet weak var clientsCollectionView: UICollectionView! {
        didSet {
            let cellData    = Constants.Cell.client
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            clientsCollectionView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
            clientsCollectionView.ept.dataSource = self
        }
    }

    @IBOutlet weak var calendarView: JTAppleCalendarView!{
        didSet{
            let cellData    = Constants.CalendarCell.TemplateCalendar
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            self.calendarView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
            
            self.calendarView.minimumInteritemSpacing   = 0
            self.calendarView.minimumLineSpacing        = 0
            
            self.calendarView.scrollingMode             = .stopAtEachCalendarFrame
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
            let formatter       = DateFormatters.serverTimeFormatter
            formatter.timeZone = TimeZone(identifier: "UTC")
        }
    }
    
    var clients: [Client] = [] {
        didSet {
        }
    }
    
    var event = Event()
    
    
    lazy var selectClientsVC: SelectClientsVC? = {
        
        guard let controller = UIStoryboard.trainer.SelectClients else { return UIViewController() as? SelectClientsVC }
        
        return controller
    }()
    
    var changedDate = DateInRegion(absoluteDate: Date())
    
    var startTime: String = ""
    var endTime: String = ""
    
    //MARK: IBActions
    
    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextMonthButtonPressed(_ sender: Any) {
       nextMonth()
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
       previousMonth()
    }
    
    @IBAction func addClientButtonPressed(_ sender: Any) {
        guard let controller =  selectClientsVC else { return }
        
        controller.delegate = self
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //TODO: Use separated method
    @IBAction func saveScheduleButtonPressed(_ sender: Any) {
        var clientIdies: [Int] = []
        
        for client in clients {
            clientIdies.append(client.id ?? 0)
        }
        let set = Set(clientIdies)
        clientIdies = Array(set)
        
        let dateformatter = DateFormatters.serverTimeFormatter
        dateformatter.dateFormat = "hh:mm"

        dateformatter.dateFormat = "yyyy-MM-dd"
        dateformatter.timeZone = TimeZone(identifier: "UTC")
        let date: String = dateformatter.string(from: changedDate.absoluteDate)
        
        //        if !self.compareDates(self.startTime, self.endTime) {
        //            showAler()
        //            return
        //        }
        
        event.location  = self.locationTextField.text ?? ""
        event.title     = self.eventTitleTextField.text
        event.startAt   = self.startTime
        event.endAt     = self.endTime
        event.date      = date
        event.clientsForUpload = clientIdies
        
        uploadEvent()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Private
    
    private func nextMonth() {
        changedDate = changedDate + 1.month
        self.calendarView.scrollToDate(changedDate.absoluteDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .left, extraAddedOffset: 0) {
            self.fillMonthYearLabelsWith(self.changedDate.absoluteDate)
        }
    }
    
    private func previousMonth() {
        changedDate = changedDate - 1.month
        self.calendarView.scrollToDate(changedDate.absoluteDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: .left, extraAddedOffset: 0) {
            self.fillMonthYearLabelsWith(self.changedDate.absoluteDate)
        }
    }
    
    private func startDatePicker() -> UIDatePicker {
        let startPicker = createDatePicker()
        startPicker.addTarget(self, action: #selector(ScheduleClientVC.startPickerValueChanged), for: UIControlEvents.valueChanged)
        return startPicker
    }
    
    private func endDatePicker() -> UIDatePicker {
        let endPicker = createDatePicker()
        endPicker.addTarget(self, action: #selector(ScheduleClientVC.endPickerValueChanged), for: UIControlEvents.valueChanged)
        return endPicker
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = .time
        datePickerView.minuteInterval = 10
        return datePickerView
    }
    
    @objc private func startPickerValueChanged(sender: UIDatePicker) {
        self.startDateTextField.text = self.datePickerFormatter(start: true, date: sender.date)
    }
    
    @objc private func endPickerValueChanged(sender: UIDatePicker) {
        self.endDateTextField.text = self.datePickerFormatter(start: false, date: sender.date)
    }
    
    private func datePickerFormatter(start: Bool, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let dateAsString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"

        let date24 = dateFormatter.string(from: date)
        if start {
            self.startTime = date24
        }else {
            self.endTime = date24
        }
        
        return dateAsString
    }
    
    private func compareDates(_ startDate: String, _ endDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard  let start = dateFormatter.date(from: startDate), let end = dateFormatter.date(from: endDate) else {
            return false
        }
        
        return end > start
    }
    
    private func showAler() {
        let alert = UIAlertController(title: "Last date must be grater than start!", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //TODO: Make good solution
//    private func decreaseDate(_ decrease: Bool?) {
//
//        if let decrease = decrease {
//            if decrease {
//                changedDate = changedDate + 1.day
//            }else {
//                changedDate = changedDate - 1.day
//            }
//        }
//
//        updateDateUI()
//    }
    
//    private func updateDateUI() {
//        let dateformatter = DateFormatters.serverTimeFormatter
//        dateformatter.dateFormat = "EEEE"
//        let dayOfWeak: String = dateformatter.string(from: changedDate.absoluteDate)
//        dateformatter.dateFormat = "MMMM yyyy"
//        let monthYear: String = dateformatter.string(from: changedDate.absoluteDate)
//        dateformatter.dateFormat = "dd"
//        let digitOfDay: String = dateformatter.string(from: changedDate.absoluteDate)
//
//        self.dayOfWeakLabel.text    = dayOfWeak
//        self.dayOfMonthLabel.text   = digitOfDay
//        self.monthYearLabel.text    = monthYear
//    }
    
    func uploadEvent() {
        Event.createEvent(eventData: self.event) { (error) in
            if let error = error {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func fillMonthYearLabelsWith(_ date: Date) {
        self.changedDate = DateInRegion(absoluteDate: date)
        let formatter                   = DateFormatters.monthYearFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        let textToSee = formatter.string(from: date)
        let subText = textToSee.components(separatedBy: " ")
        self.monthLabel.text = subText[0]
        self.yearLabel.text = subText[1]
    }
}

extension ScheduleClientVC: UITextFieldDelegate {
     func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.inputView is UIDatePicker {
            if textField == startDateTextField {
                self.startDateTextField.text = self.datePickerFormatter(start: true, date: Date())
            }else {
                self.endDateTextField.text = self.datePickerFormatter(start: false, date: Date())
            }
        }
    }
}

extension ScheduleClientVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clients.count
    }
    
    //TODO: Make Bindable
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.client.identifier, for: indexPath) as? ScheduleClientCollectionViewCell else { return UICollectionViewCell() }
        
        let client = self.clients[indexPath.row]
        
        if let url = client.clientAvatar {
            cell.clientPhotoImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
        }else {
            cell.clientPhotoImageView.image = UIImage(named: "profile")
        }
        return cell
    }
}

extension ScheduleClientVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.clientsCollectionView.bounds
        return CGSize(width: ((size.width - 5) / 5) - 1, height: ((size.width - 5) / 5) - 1)
    }
}

extension ScheduleClientVC: SelectClientsVCDelegate {
    func clientSelected(_ client: Client, on controller: SelectClientsVC) {
        self.clients.append(client)
        self.clients = self.clients.filter{ $0.isSelected }
        let set = Set(self.clients)
        self.clients = Array(set)
        self.clientsCollectionView.reloadData()
    }
}
extension ScheduleClientVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let formatter       = DateFormatters.serverTimeFormatter
        formatter.timeZone  = TimeZone(identifier: "UTC")
        guard let start = formatter.date(from: "2017-01-01"), let end = formatter.date(from: "2022-01-01") else { return ConfigurationParameters(startDate: Date(), endDate: Date()) }
        let parameters = ConfigurationParameters(startDate: start, endDate: end, numberOfRows: 1, calendar: calendar, generateInDates: .forFirstMonthOnly, generateOutDates: .off)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.CalendarCell.TemplateCalendar.identifier, for: indexPath) as? CreateTemplateCalendarCell else { return JTAppleCell() }
        
        cell.monthDayLabel.text = cellState.text
        cell.weekDayLabel.text =  cellState.date.dayOfWeek()
        
        cellState.templateCalendarCellselected(cell: cell)
        return cell
    }
}

extension ScheduleClientVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        cellState.templateCalendarCellselected(cell: cell as! CreateTemplateCalendarCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let calCell = cell as? CreateTemplateCalendarCell else { return }
        cellState.templateCalendarCellselected(cell: calCell)
        
        fillMonthYearLabelsWith(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CreateTemplateCalendarCell else { return }
        
        cellState.templateCalendarCellselected(cell: calCell)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        for date in visibleDates.monthDates {
            if (calendar.cellStatus(for: date.date)?.isSelected) ?? false {
                fillMonthYearLabelsWith(date.date)
                return
            }
        }
        guard  let date = visibleDates.monthDates.first?.date else { return }
        //self.chnagedDate = DateInRegion(absoluteDate: date)
        self.fillMonthYearLabelsWith(date)
    }
}

extension ScheduleClientVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "Press the + to add clients"
    }
    
    var emptyImageName: String {
        return ""
    }
    
    var fontSize: CGFloat {
        return 25.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}
