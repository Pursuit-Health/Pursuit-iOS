//
//  ClientInfoVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import SwipeCellKit
import EmptyKit
import PullToRefreshSwift

protocol ClientInfoVCDelegate: class {
    func selected(workout: Workout, on controller: ClientInfoVC, client: Client?)
    func addWorkoutButtonPressed(on controller: ClientInfoVC)
    func deleteWorkout(_ workout: Workout, on controller: ClientInfoVC)
}

protocol ClientInfoVCDatasource: class {
    typealias GetClientTemplates = (_ client: User, _ workout: [Workout]?) -> Void
    func loadInfo(controller: ClientInfoVC, completion: @escaping GetClientTemplates)
}

extension ClientInfoVCDelegate {
    func addWorkoutButtonPressed(on controller: ClientInfoVC) {}
}

class ClientInfoVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var clientInfoTableView: UITableView! {
        didSet {
            self.clientInfoTableView.estimatedRowHeight = 100
            self.clientInfoTableView.rowHeight = UITableViewAutomaticDimension
            self.clientInfoTableView.ept.dataSource = self
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Variables
    
    weak var delegate: ClientInfoVCDelegate?
    weak var dataSource: ClientInfoVCDatasource?
    var client: User? {
        didSet {
            if let url = client?.avatar {
                 DispatchQueue.main.async {
                    self.profileImageView.sd_addActivityIndicator()
                    self.profileImageView.sd_setIndicatorStyle(.gray)
                    self.profileImageView.sd_setImage(with: URL(string: url.persuitImageUrl()),
                                             placeholderImage: UIImage(named: "user"))
                }
            }
            self.navigationItem.leftTitle = client?.name ?? ""
        }
    }
    var workouts: [Workout] = [] {
        didSet {            
            self.clientInfoTableView?.reloadData()
            let doneCount = workouts.filter{ $0.isDone ?? false }.count
            let todoCount = workouts.count - doneCount
            
            self.completedLabel.text = String(doneCount)
            self.todoLabel.text = String(todoCount)
        }
    }
    
    var dateFormatter = DateFormatter()
    
    //MARK: IBActions

    @IBAction func addWorkoutButtonPressed(_ sender: Any) {
        self.delegate?.addWorkoutButtonPressed(on: self)
        //Create action sheet for selecting templates
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clientInfoTableView.addPullRefresh { _ in
            self.updateWorkouts()
        }
        self.clientInfoTableView?.startPullRefresh()
    
        self.setUpBackgroundImage()
        
        self.subscribeForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpNavigationBar()
        
        //self.updateWorkouts()
    }
    
    deinit {
        self.unsubscribeForNotifications()
    }
    
    //MARK: Private
    
    func avatarUpdated(_ notification: Notification) {
        self.updateInfo()
    }
    
    func updateWorkouts() {
        self.dataSource?.loadInfo(controller: self, completion: { (client, workouts) in
            self.client = client
            self.workouts = workouts ?? []
           self.clientInfoTableView?.stopPullRefreshEver()
        })
    }
    
    private func updateInfo() {
        User.getUserInfo { (user, error) in
            self.client = user
        }
    }
    
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.setAppearence()
    }
    
    private func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ClientInfoVC.avatarUpdated(_:)), name: NSNotification.Name(rawValue: "AvatarUpdated"), object: nil)
    }
    
    private func unsubscribeForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ClientInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientInfoCell.self) else { return UITableViewCell() }
        let trainigDate = workouts[indexPath.row]
        
        cell.selectedCell = trainigDate.isDone ?? false
        cell.templateNameLabel.text   = trainigDate.name
        if User.shared.type == .trainer {
            cell.delegate = self
        }
        let date = Date(timeIntervalSince1970: (trainigDate.startAt ?? 0))
        dateFormatter.dateFormat = "MM/dd/YYYY"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        cell.dateLabel.text     = dateFormatter.string(from: date)
        
        return cell
    }
}

extension ClientInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if workouts[indexPath.row].isDone ?? false { return }
        //if !(self.workouts[indexPath.row].isDone ?? false){
            self.delegate?.selected(workout: self.workouts[indexPath.row], on: self, client: self.client as? Client)
        //}
    }
}

extension ClientInfoVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
             let workout = self.workouts[indexPath.row]
             self.delegate?.deleteWorkout(workout, on: self)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.transitionStyle = .border
        options.expansionStyle = .none
        options.buttonPadding = 0
        
        return options
    }
}

extension ClientInfoVC: PSEmptyDatasource {
    var emptyTitle: String {
         return "No more exercises to complete!"
    }
    
    var emptyImageName: String {
        return "check_mark_empty_dataSet"
    }
    
    var fontSize: CGFloat {
        return 25.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}

