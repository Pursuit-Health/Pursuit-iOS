//
//  WeightsCell.swift
//  Pursuit
//
//  Created by ігор on 6/4/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class WeightsCell: AddExerciseCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.exerciseTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WeightsCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let sub = UserSettings.shared.weightsType.name
        textField.text = textField.text?.replacingOccurrences(of: " \(sub)", with: "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let sub = UserSettings.shared.weightsType.name
        let text = (textField.text ?? "") + " \(sub)"
        textField.text = text
    }
}
