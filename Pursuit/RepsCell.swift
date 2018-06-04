//
//  RepsCell.swift
//  Pursuit
//
//  Created by ігор on 6/4/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class RepsCell: AddExerciseCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.exerciseTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RepsCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: " reps", with: "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = (textField.text ?? "") + " reps"
        textField.text = text
    }
}
