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
}
