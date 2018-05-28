//
//  ConfigureSetsTableViewCell.swift
//  Pursuit
//
//  Created by ігор on 5/15/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ConfigureSetsCell: UITableViewCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exImageView: UIImageView!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var headerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
