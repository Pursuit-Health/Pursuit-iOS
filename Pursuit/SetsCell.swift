//
//  SetsCell.swift
//  Pursuit
//
//  Created by ігор on 6/1/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SetsCell: AddExerciseCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.exerciseTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SetsCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: " sets", with: "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var text = String()
        if textField.text?.isEmpty ?? true {
            text = ""
        }else {
            text = (textField.text ?? "") + " sets"
        }
        textField.text = text
    }
}
