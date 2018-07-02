//
//  ClientRequestsTableViewCell.swift
//  Pursuit
//
//  Created by Igor Makara on 6/28/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ClientRequestsTableViewCellDelegate: class {
    func acceptButtonPressed(on cell: ClientRequestsTableViewCell)
    func denyButtonPressed(on cell: ClientRequestsTableViewCell)
}

class ClientRequestsTableViewCell: UITableViewCell {
    
    //MARK: Variables
    
    weak var delegate: ClientRequestsTableViewCellDelegate?
    
    //MARK: IBActions
    
    @IBAction func denyButtonPressed(_ sender: Any) {
        delegate?.denyButtonPressed(on: self)
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        delegate?.acceptButtonPressed(on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
