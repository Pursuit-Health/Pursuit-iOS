//
//  TrainingVC.swift
//  Pursuit
//
//  Created by ігор on 8/4/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainingVC: UIViewController {
    //MARK: Constants
    
    struct Constants {
        struct Identifiers{
            static let TrainingCell         = "TrainingTableViewCell"
            static let TrainingCellReuseID  = "TrainingCellReuseID"
        }
    }
    
    //MARK: IBOutlets
    
    //MARK: Variables
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Private
    private func configureTableView(){
        
    }
    
    private func registerXibs(){
        
    }
}

//MARK: UITableViewDataSource
extension TrainingVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

//MARK: UITableViewDelegate
extension TrainingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}
