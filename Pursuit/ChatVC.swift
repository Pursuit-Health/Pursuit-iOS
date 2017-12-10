//
//  ChatVC.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView! {
        didSet {
            self.messagesTableView.estimatedRowHeight = 100
            self.messagesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    let messages = ["Looooooooooooosfmismdfksdmfksdmfksdmfksmdfksmdfksdfmskdfmskdfmksdf", "skfsfsofkoskfosdkfosdkfoskfdoskfosdkfos", "skdfsfsdfsfjiuhgeuirgsdifisdjfisjf", "skfsidfsifisdjisdfjisfjsidf", "skdfksdmskdfms", "kdmsdmsdfijsd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.gc_dequeueReusableCell(type: FrontSenderWithImageCell.self) else  { return UITableViewCell() }
            return cell
        }
        guard let cell = tableView.gc_dequeueReusableCell(type: FrontSenderCell.self) else  { return UITableViewCell() }
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let castedCell = cell as? FrontSenderCell else { return }
        //castedCell.setUpCornerRadius()
        
    }
}
