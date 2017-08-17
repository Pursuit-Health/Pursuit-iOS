//
//  ScheduleClientVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 7/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

//TODO: Same
class ScheduleClientVC: UIViewController {
    
    @IBOutlet weak var scheduleClientTableView: UITableView!{
        didSet{
            scheduleClientTableView.rowHeight = UITableViewAutomaticDimension
            scheduleClientTableView.estimatedRowHeight = 200
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ScheduleClientVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.gc_dequeueReusableCell(type: ScheduleClienCell.self) else { return UITableViewCell() }
        
        return cell
    }
}
