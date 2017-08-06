//
//  CreateTemplateVC.swift
//  Pursuit
//
//  Created by ігор on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class CreateTemplateVC: UIViewController {

    //MARK: Constants
    
    struct Constants {
        struct Identifiers{
            static let TrainingCell         = "TrainingTableViewCell"
            static let TrainingCellReuseID  = "TrainingCellReuseID"
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var templateTableView: UITableView!
    
    //MARK: Variables
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        registerXibs()
        
    }
    
    //MARK: Private
    private func configureTableView(){
        templateTableView.rowHeight = UITableViewAutomaticDimension
        templateTableView.estimatedRowHeight = 200
        
        templateTableView.separatorColor = UIColor.tableSeparatorViewColor()
        templateTableView.tableFooterView = UIView()
        
    }
    
    private func registerXibs() {
        templateTableView.register(UINib(nibName: Constants.Identifiers.TrainingCell, bundle: nil),
                                   forCellReuseIdentifier: Constants.Identifiers.TrainingCellReuseID)
    }
}

//MARK: UITableViewDataSource
extension CreateTemplateVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.TrainingCellReuseID, for: indexPath) as? TrainingTableViewCell else {return UITableViewCell()}
        return cell
        
    }
}

//MARK: UITableViewDelegate
extension CreateTemplateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
