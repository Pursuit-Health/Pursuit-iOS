//
//  SignUpDataCell.swift
//  Pursuit
//
//  Created by Igor on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignUpDataCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var userDataTextField: AnimatedTextField!
    @IBOutlet weak var cellImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
