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
    
    //MARK: Constants
    
    fileprivate struct Constants {
        struct Dates {
            static let StartDate    = "2017 01 01"
            static let EndDate      = "2022 12 31"
            static let DateFormat   = "yyyy MM dd"
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
    
    let formatter   = DateFormatter()
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
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = Constants.Dates.DateFormat
        let calendar = Calendar.current
        
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale
        
        let start = formatter.date(from: Constants.Dates.StartDate)!
        let end = formatter.date(from: Constants.Dates.EndDate)!
        
        let params = ConfigurationParameters(startDate: start, endDate: end)
        return params
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        if(cellState.dateBelongsTo == DateOwner.previousMonthWithinBoundary || cellState.dateBelongsTo == DateOwner.followingMonthWithinBoundary)  {
            cell.dateLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        } else {
            cell.dateLabel.textColor = UIColor(white: 1.0, alpha: 1.0)
        }
        cell.bgView.layer.borderWidth = 0.0
        cell.bgView.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        if cellState.date == formatter.date(from: "2017-08-09 21:00:00 +0000") {
            cell.bgView.layer.borderWidth = 1.0
            cell.bgView.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            if(selectedCell != nil) {
                selectedCell.bgView.layer.borderWidth = 0.0
                selectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
            }
            selectedCell = cell
        }
        return cell
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let calCell = cell as! CalendarCell
        calCell.bgView.layer.borderWidth = 1.0
        calCell.bgView.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        if(selectedCell != nil) {
            selectedCell.bgView.layer.borderWidth = 0.0
            selectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
        }
        selectedCell = calCell
        print(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        self.formatter.dateFormat = ("MMMM yyyy")
        updateLeftTitle(newTitle: self.formatter.string(from: date!))
   
    }
}
