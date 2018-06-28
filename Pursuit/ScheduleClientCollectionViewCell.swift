//
//  ScheduleClientCollectionViewCell.swift
//  Pursuit
//
//  Created by ігор on 9/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ScheduleClientCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var clientPhotoImageView: UIImageView!
    @IBOutlet weak var clientName: UILabel! {
        didSet {
            clientName.adjustsFontSizeToFitWidth = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
