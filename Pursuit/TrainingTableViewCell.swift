//
//  TrainingTableViewCell.swift
//  Pursuit
//
//  Created by ігор on 8/4/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainingTableViewCell: UITableViewCell {

    @IBOutlet weak var exercisesNameLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
