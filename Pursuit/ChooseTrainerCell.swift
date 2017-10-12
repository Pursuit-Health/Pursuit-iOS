//
//  ChooseTrainerCell.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ChooseTrainerCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var trainerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
