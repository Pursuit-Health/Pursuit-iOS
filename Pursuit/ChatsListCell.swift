//
//  ChatsListCell.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ChatsListCell: UITableViewCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var timeModifiedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
