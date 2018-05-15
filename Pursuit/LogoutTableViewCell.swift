//
//  LogoutTableViewCell.swift
//  Pursuit
//
//  Created by Igor on 5/14/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
protocol LogoutTableViewCellDelegate: class {
    func logoutButtonPressedOn(_ cell: LogoutTableViewCell)
}

class LogoutTableViewCell: UITableViewCell {
    
    weak var delegate: LogoutTableViewCellDelegate?
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.delegate?.logoutButtonPressedOn(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
