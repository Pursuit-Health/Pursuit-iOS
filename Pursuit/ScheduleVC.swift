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
    }
    
    //MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet var headerLabelsView  : UIStackView! {
        didSet {
            headerLabelsView.backgroundColor = UIColor(white: 255.0/255.0, alpha: 0.1)
        }
    }
    
    @IBOutlet weak var leftTitleBarButtonItem   : UIBarButtonItem!
    @IBOutlet var calendarView                  : JTAppleCalendarView!
    
    //MARK: Variables
    
    var formatter   = DateFormatter()
    var curCal      = Calendar.current
    
    var selectedCell    : CalendarCell!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionView()
        
        setupCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewVisibleDates()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
    }
    
    //MARK: Private
    
    private func registerCollectionView() {
        collectionView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellWithReuseIdentifier: "scheduleCell")
    }
    
    private func setupCalendarView() {
        
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.minimumLineSpacing = 0
        
        self.calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        self.calendarView.scrollToDate(Date())
        self.calendarView.selectDates([Date()], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        
        calendarViewVisibleDates()
    }
    
    private func calendarViewVisibleDates() {
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first?.date
            self.formatter.dateFormat = ("MMMM yyyy")
            
            self.navigationItem.leftTitle = self.formatter.string(from: date!)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ScheduleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCell", for: indexPath) as? ScheduleCell else { return UICollectionViewCell() }
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
        
        setUpDateFormatter()
        
        return configurationParameters()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(cell: cell, cellState: cellState)
        
        handleCellSelection(cell: cell, cellState: cellState)
        
        return cell
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        handleCellTextColor(cell: calCell, cellState: cellState)
        handleCellSelection(cell: calCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
        
        handleCellTextColor(cell: calCell, cellState: cellState)
        handleCellSelection(cell: calCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard  let date = visibleDates.monthDates.first?.date else { return }
        self.formatter.dateFormat = ("MMMM yyyy")
        
        self.navigationItem.leftTitle = self.formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        return date.compare(Date()) == .orderedAscending
    }
    
}
private extension ScheduleVC {
    func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
        let myCustomCell = cell
        
        if cellState.isSelected {
            myCustomCell.dateLabel.textColor = UIColor.white
        } else {
            myCustomCell.dateLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? .white : .gray
        }
    }
    
    func handleCellSelection(cell: CalendarCell, cellState: CellState) {
        let myCustomCell = cell
        
        myCustomCell.isSpecialDate = cellState.date.compare(Date()) == .orderedAscending
        
        if cellState.isSelected {
            myCustomCell.bgView.clipsToBounds           = true
            myCustomCell.bgView.isHidden                = false
            
            myCustomCell.bgView.backgroundColor         = UIColor.clear
            myCustomCell.bgView.layer.borderWidth       = 1.0
            myCustomCell.bgView.layer.borderColor       = UIColor.cellSelection().cgColor
        } else {
            myCustomCell.bgView.isHidden                = true
        }
    }
}

private extension ScheduleVC {
    func setUpDateFormatter() {
        
        formatter           = DateFormatters.projectFormatFormatter
        let calendar        = Calendar.current
        
        formatter.timeZone  = calendar.timeZone
        formatter.locale    = calendar.locale
    }
    
    func configurationParameters() -> ConfigurationParameters {
        let start           = formatter.date(from: Constants.Dates.StartDate)!
        let end             = formatter.date(from: Constants.Dates.EndDate)!
        
        let params          = ConfigurationParameters(startDate: start, endDate: end)
        return params
    }
}
