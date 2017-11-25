//
//  ClientInfoVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

protocol ClientInfoVCDelegate: class {
    func selected(workout: Workout, on controller: ClientInfoVC)
}

protocol ClientInfoVCDatasource: class {
    typealias GetClientTemplates = (_ client: User, _ workout: [Workout]?) -> Void
    func loadInfo(controller: ClientInfoVC, completion: @escaping GetClientTemplates)
}

class ClientInfoVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var clientInfoTableView: UITableView! {
        didSet {
            self.clientInfoTableView.estimatedRowHeight = 100
            self.clientInfoTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Variables
    
    weak var delegate: ClientInfoVCDelegate?
    weak var dataSource: ClientInfoVCDatasource?
    var client: User? {
        didSet {
            if let url = client?.avatar {
                profileImageView.sd_setImage(with: URL(string: url.persuitImageUrl()),
                                             placeholderImage: UIImage(named: "profile"))
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

    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setAppearence()
        
        self.dataSource?.loadInfo(controller: self, completion: { (client, workouts) in
            self.client = client
            self.workouts = workouts ?? []
        })
    }
}

extension ClientInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientInfoCell.self) else { return UITableViewCell() }
        cell.delegate = self
        let trainigDate = workouts[indexPath.row]
        
        cell.selectedCell             = trainigDate.isDone ?? false
        cell.templateNameLabel.text   = trainigDate.name
        
        let date = Date(timeIntervalSince1970: (trainigDate.startAt ?? 0))
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        cell.dateLabel.text      = dateFormatter.string(from: date)
        
        return cell
    }
}

extension ClientInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selected(workout: self.workouts[indexPath.row], on: self)
    }
}

extension ClientInfoVC: ClientInfoCellDelegate {
    func didTappedOnImage(cell: ClientInfoCell) {
        if let index = self.clientInfoTableView.indexPath(for: cell) {

        }
    }
}
