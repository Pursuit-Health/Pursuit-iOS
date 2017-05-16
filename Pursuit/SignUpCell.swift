//
//  SignUpCell.swift
//  VideoStreaming
//
//  Created by Kent Guerriero on 1/17/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import UIKit

class SignUpCell: UITableViewCell {

    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var nameField: DezappTextField!
    @IBOutlet var emailField: DezappTextField!
    @IBOutlet var passwordField: DezappTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameField.updateAttributedTextWithString(string: "")
        emailField.updateAttributedTextWithString(string: "")
        passwordField.updateAttributedTextWithString(string: "")
    }
    
}
