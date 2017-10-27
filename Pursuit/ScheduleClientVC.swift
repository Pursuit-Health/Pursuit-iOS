//
//  ScheduleClientVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 7/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwiftDate

//TODO: Same
class ScheduleClientVC: UIViewController {
    
    //MARK: Constants
    
    struct Constants {
        struct Cell {
            var nibName: String
            var identifier: String
            
            static let client = Cell(nibName: "ScheduleClientCollectionViewCell", identifier: "ScheduleClientCollectionViewCellReuseID")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var dayOfMonthLabel  : UILabel!
    @IBOutlet weak var dayOfWeakLabel   : UILabel!
    @IBOutlet weak var monthYearLabel   : UILabel!
    @IBOutlet weak var eventTitleTextField: UITextField!
    
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
    
    @IBOutlet weak var clientsCollectionView: UICollectionView! {
        didSet {
            let cellData    = Constants.Cell.client
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            clientsCollectionView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
        }
    }
    
    var clients: [Client] = [] {
        didSet {
        }
    }
    
    var event = Event()
    
    
    lazy var selectClientsVC: SelectClientsVC? = {
        
        guard let controller = UIStoryboard.Trainer.SelectClients else { return UIViewController() as? SelectClientsVC }
        
        return controller
    }()
    
    var changedDate = DateInRegion(absoluteDate: Date())
    
    var startTime: String = ""
    var endTime: String = ""
    
    //MARK: IBActions
    
    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func decreaseDateButtonPressed(_ sender: Any) {
        decreaseDate(true)
    }
    
    @IBAction func encreaseDateButtonPressed(_ sender: Any) {
        decreaseDate(false)
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
        //let startTime: String = dateformatter.string(from: startDatePicker.date)
        //let endTime: String = dateformatter.string(from: enadDatePicker.date)
        
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateformatter.string(from: changedDate.absoluteDate)
        
        //        if !self.compareDates(self.startTime, self.endTime) {
        //            showAler()
        //            return
        //        }
        
        event.location = "SomeWhere"
        event.startAt = self.startTime
        event.endAt = self.endTime
        event.date = date
        event.clientsForUpload = clientIdies
        
        uploadEvent()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decreaseDate(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Private
    
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
        self.startDateTextField.text = self.datePickerFormatter(start: true, sender: sender)
    }
    
    @objc private func endPickerValueChanged(sender: UIDatePicker) {
        self.endDateTextField.text = self.datePickerFormatter(start: false, sender: sender)
    }
    
    private func datePickerFormatter(start: Bool, sender: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let dateAsString = dateFormatter.string(from: sender.date)
        let date = dateFormatter.date(from:dateAsString)
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from:date!)
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
    private func decreaseDate(_ decrease: Bool?) {
        
        if let decrease = decrease {
            if decrease {
                changedDate = changedDate + 1.day
            }else {
                changedDate = changedDate - 1.day
            }
        }
        
        let dateformatter = DateFormatters.serverTimeFormatter
        dateformatter.dateFormat = "EEEE"
        let dayOfWeak: String = dateformatter.string(from: changedDate.absoluteDate)
        dateformatter.dateFormat = "MMMM yyyy"
        let monthYear: String = dateformatter.string(from: changedDate.absoluteDate)
        dateformatter.dateFormat = "dd"
        let digitOfDay: String = dateformatter.string(from: changedDate.absoluteDate)
        
        self.dayOfWeakLabel.text    = dayOfWeak
        self.dayOfMonthLabel.text   = digitOfDay
        self.monthYearLabel.text    = monthYear
    }
    
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
