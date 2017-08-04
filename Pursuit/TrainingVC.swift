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
    @IBOutlet weak var trainingTableView: UITableView!
    
    //MARK: Variables
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerXibs()

    }
    
    //MARK: Private
    private func configureTableView(){
        trainingTableView.rowHeight = UITableViewAutomaticDimension
        trainingTableView.estimatedRowHeight = 200
        
    }
    
    private func registerXibs() {
        trainingTableView.register(UINib(nibName: "TrainingTableViewCell", bundle: nil),
        forCellReuseIdentifier: Constants.Identifiers.TrainingCellReuseID)
    }
}

//MARK: UITableViewDataSource
extension TrainingVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.TrainingCellReuseID, for: indexPath) as? TrainingTableViewCell else {return UITableViewCell()}
        return cell

    }
}

//MARK: UITableViewDelegate
extension TrainingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
