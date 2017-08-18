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

    //TODO: move all date formats into ona place. Ask me to show how and where
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
    
    @IBOutlet var calendarView      : JTAppleCalendarView!
    
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
        // self.calendarView.selectDates([Date()]
        
        calendarViewVisibleDates()
    }
    
    private func calendarViewVisibleDates() {
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first?.date
            self.formatter.dateFormat = ("MMMM yyyy")
            self.updateLeftTitle(newTitle: self.formatter.string(from: date!))
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
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
    //TODO: This methods need to be separated with more methods
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        setUpDateFormatter()
        
        return configurationParameters()
    }
    
   
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        
        cell.dateLabel.text = cellState.text
        
        handleCellState(cellState, for: cell)
        
        settingBorderColorAndWidth(borderColor: UIColor.cellSelection(), borderWidth: 0.0, for: cell)
        
        formatter = DateFormatters.fullFormat
        
        if cellState.date != formatter.date(from: "2017-08-09 21:00:00 +0000") { return cell }
            
            settingBorderColorAndWidth(borderColor: UIColor.cellSelection(), borderWidth: 1.0, for: cell)
            if(selectedCell != nil) {
            selectedCell = handleDateSelection(calCell: selectedCell, color: UIColor.clear, borderWidth: 0.0)
            }
            selectedCell = cell
        
        return cell
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate {
    
    //TODO: this also need to be separated
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let calCell = cell as? CalendarCell else { return }
    
        selectedCell = handleDateSelection(calCell: calCell, color: UIColor.cellSelection(), borderWidth: 1.0)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard  let date = visibleDates.monthDates.first?.date else { return }
        self.formatter.dateFormat = ("MMMM yyyy")
        updateLeftTitle(newTitle: self.formatter.string(from: date))
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
        let start   = formatter.date(from: Constants.Dates.StartDate)!
        let end     = formatter.date(from: Constants.Dates.EndDate)!
        
        let params  = ConfigurationParameters(startDate: start, endDate: end)
        return params
    }
    
    func settingBorderColorAndWidth(borderColor: UIColor, borderWidth: CGFloat, for cell: CalendarCell) {
        cell.bgView.layer.borderWidth = borderWidth
        cell.bgView.layer.borderColor = borderColor.cgColor
    }
    
    func handleCellState(_ cellState: CellState,for cell: CalendarCell) {
        var color = UIColor()
        if(cellState.dateBelongsTo == DateOwner.previousMonthWithinBoundary || cellState.dateBelongsTo == DateOwner.followingMonthWithinBoundary)  {
            color = UIColor(white: 1.0, alpha: 0.5)
        } else {
            color = UIColor(white: 1.0, alpha: 1.0)
        }
        
        cell.dateLabel.textColor = color
    }
    
    func handleDateSelection(calCell: CalendarCell, color: UIColor, borderWidth: CGFloat) -> CalendarCell {
        calCell.bgView.layer.borderWidth = borderWidth
        calCell.bgView.layer.borderColor = color.cgColor
        
        return calCell
    }
}
