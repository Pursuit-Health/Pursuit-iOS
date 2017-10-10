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
    
    @IBOutlet weak var startDatePicker: UIDatePicker! {
        didSet {
            self.startDatePicker.datePickerMode = .time
        }
    }
    
    @IBOutlet weak var enadDatePicker: UIDatePicker! {
        didSet {
            self.enadDatePicker.datePickerMode = .time
            self.enadDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
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
        let storyboard = UIStoryboard(name: Storyboards.Trainer, bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: Controllers.Identifiers.SelectClients)as? UINavigationController)?.visibleViewController as? SelectClientsVC
        
        return controller
    }()
    
    var changedDate = DateInRegion(absoluteDate: Date())
    
    
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
        
        let dateformatter = DateFormatters.serverTimeFormatter
        dateformatter.dateFormat = "hh:mm"
        let startTime: String = dateformatter.string(from: startDatePicker.date)
        let endTime: String = dateformatter.string(from: enadDatePicker.date)
        
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateformatter.string(from: Date())
        
        event.location = eventTitleTextField.text ?? ""
        event.startAt = startTime
        event.endAt = endTime
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
    
    func decreaseDate(_ decrease: Bool?) {

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
            if error == nil {
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
               self.clientsCollectionView.reloadData()
    }
}
