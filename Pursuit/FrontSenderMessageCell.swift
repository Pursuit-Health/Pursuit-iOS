//
//  FrontSenderCell.swift
//  Pursuit
//
//  Created by ігор on 12/8/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class FrontSenderMessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
