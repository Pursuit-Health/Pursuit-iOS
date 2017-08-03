//
//  ScheduleVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ScheduleVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let formatter = DateFormatter()
    var curCal = Calendar.current
    var navController: PursuitNVC!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerLabelsView: UIStackView!
    @IBOutlet var calendarView: JTAppleCalendarView!
    var selectedCell:CalendarCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellWithReuseIdentifier: "scheduleCell")
        collectionView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        headerLabelsView.backgroundColor = UIColor(white: 255.0/255.0, alpha: 0.1)
        
        navController = self.navigationController as! PursuitNVC
        
        let addScheduleButton = UIBarButtonItem(image: UIImage(named: "ic_plus"), style: .plain, target: self, action:#selector(self.addSchedule))
        self.tabBarController?.navigationItem.rightBarButtonItem  = addScheduleButton
        
        setupCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first?.date
            self.formatter.dateFormat = ("MMMM yyyy")
            self.navController.setTitle(text: self.formatter.string(from: date!))
        }
    }
    
    func  setupCalendarView() {
        calendarView.minimumInteritemSpacing = 0
        calendarView.minimumLineSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first?.date
            self.formatter.dateFormat = ("MMMM yyyy")
            self.navController.setTitle(text: self.formatter.string(from: date!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func addSchedule() {
        let scheduleClientVC : ScheduleClientVC = storyboard?.instantiateViewController(withIdentifier: "ScheduleClientVC") as! ScheduleClientVC
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = .currentContext // Display on top of current UIView
        self.present(scheduleClientVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UICollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ScheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
}

extension ScheduleVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let start = formatter.date(from: "2017 01 01")!
        let end = formatter.date(from: "2022 12 31")!
        
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
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let calCell = cell as! CalendarCell
        calCell.bgView.layer.borderWidth = 1.0
        calCell.bgView.layer.borderColor = UIColor(colorLiteralRed: 140.0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        if(selectedCell != nil) {
            selectedCell.bgView.layer.borderWidth = 0.0
            selectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
        }
        selectedCell = calCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        self.formatter.dateFormat = ("MMMM yyyy")
        self.navController.setTitle(text: self.formatter.string(from: date!))
    }
}
