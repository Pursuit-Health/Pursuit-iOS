//
//  SignInCell.swift
//  VideoStreaming
//
//  Created by Kent Guerriero on 1/17/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import UIKit

class SignInCell: UITableViewCell {
    
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var submitButton: UIButton!

    @IBOutlet var passwordField: DezappTextField!
    @IBOutlet var emailField: DezappTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         submitButton.layer.backgroundColor = UIColor(colorLiteralRed: 80/255, green: 210/255, blue: 194/255, alpha: 1.0).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emailField.updateAttributedTextWithString(string: "")
        passwordField.updateAttributedTextWithString(string: "")
    }
    
}
