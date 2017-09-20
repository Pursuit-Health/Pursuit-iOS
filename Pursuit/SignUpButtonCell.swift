//
//  SignUpButtonCell.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SignUpButtonCellDelegate: class {
    func signUpButtonPressed(on cell: SignUpButtonCell)
        func termsButtonPressed(on cell: SignUpButtonCell)
}

class SignUpButtonCell: UITableViewCell {

    
    //MARK: Variables
    
    weak var delegate: SignUpButtonCellDelegate?
    
    //MARK: IBActions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        delegate?.signUpButtonPressed(on: self)
    }
    
    @IBAction func termsButtonPressed(_ sender: Any) {
        delegate?.termsButtonPressed(on: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
