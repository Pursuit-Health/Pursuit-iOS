//
//  ScheduleCell.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var clientsCountLabel: UILabel!
    @IBOutlet weak var imagesStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
