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
    
    var model: [Model] = []
    
    struct TrainingData {
        var name: String
        var date: String
        var selected: Bool = false
    }
    
    var clientInfo: [TrainingData] = [TrainingData(name: "Core training", date: "11/01/2017", selected: false), TrainingData(name: "Cardio Burn", date: "11/01/2017", selected: false), TrainingData(name: "HIT Template", date: "11/01/2017", selected: false), TrainingData(name: "Intervals", date: "11/01/2017", selected: false)]
    
    //MARK: IBActions

    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setAppearence()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.fillUserData()
        
        for info in clientInfo {
            let mod = Model(name: info.name, date: info.date, selected: info.selected)
            self.model.append(mod)
        }
        
        
    }
    
    private func fillUserData() {
         let url = client?.clientAvatar ?? ""
            //profileImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            profileImageView.sd_setImage(with: URL(string: url.persuitImageUrl()), placeholderImage: UIImage(named: "profile"))
        
        self.navigationItem.leftTitle = client?.name ?? ""
    }
}

extension ClientInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientInfoCell.self) else { return UITableViewCell() }
        cell.delegate = self
        let trainigDate = model[indexPath.row]
        
        cell.selectedCell             = trainigDate.selected
        cell.templateNameLabel.text   = trainigDate.name
        cell.dateLabel.text           = trainigDate.date
        
        return cell
    }
}

extension ClientInfoVC: ClientInfoCellDelegate {
    func didTappedOnImage(cell: ClientInfoCell) {
        if let index = self.clientInfoTableView.indexPath(for: cell) {
            let trainigDate = model[index.row]
            trainigDate.selected = !trainigDate.selected
            cell.selectedCell = trainigDate.selected
            
            //self.clientInfoTableView.reloadRows(at: [index], with: .automatic)
        }
    }
}
