//
//  AddExerciseCell.swift
//  Pursuit
//
//  Created by ігор on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class AddExerciseCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseTextField: UITextField! {
        didSet {
            exerciseTextField.keyboardAppearance = UIKeyboardAppearance.default
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
