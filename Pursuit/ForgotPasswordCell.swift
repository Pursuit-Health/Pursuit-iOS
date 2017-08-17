//
//  ForgotPasswordCell.swift
//  CoachX
//
//  Created by Kent Guerriero on 1/24/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import UIKit

class ForgotPasswordCell: UITableViewCell {

    @IBOutlet var emailField: DezappTextField!
    
    @IBOutlet var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //TODO: use ui file to do that
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 19.0
        submitButton.layer.borderColor = UIColor(colorLiteralRed: 28/255, green: 86/255, blue: 255/255, alpha: 1.0).cgColor
    }

}
