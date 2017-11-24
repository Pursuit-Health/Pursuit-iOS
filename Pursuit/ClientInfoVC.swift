//
//  ClientInfoVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class ClientInfoVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var clientInfoTableView: UITableView! {
        didSet {
            self.clientInfoTableView.estimatedRowHeight = 100
            self.clientInfoTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Variables
    
    var client: Client?
    
    var workouts: [Workout] = [] {
        didSet {
            self.clientInfoTableView?.reloadData()
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
        
        self.fillUserData()
        
        self.getClientTemplates()
    }
    
    private func fillUserData() {
         let url = client?.clientAvatar ?? ""
            profileImageView.sd_setImage(with: URL(string: url.persuitImageUrl()), placeholderImage: UIImage(named: "profile"))
        
        self.navigationItem.leftTitle = client?.name ?? ""
    }
    
    private func getClientTemplates() {
        guard let id = client?.id else { return }
        Trainer.getClientTemplates(clientId: "\(id)") { (workout, error) in
            self.workouts = workout ?? []
        }
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

extension ClientInfoVC: ClientInfoCellDelegate {
    func didTappedOnImage(cell: ClientInfoCell) {
        if let index = self.clientInfoTableView.indexPath(for: cell) {

        }
    }
}
