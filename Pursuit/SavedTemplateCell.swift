//
//  SavedTemplateCell.swift
//  Pursuit
//
//  Created by ігор on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit

class SavedTemplateCell: SwipeTableViewCell {

    @IBOutlet weak var templateNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
