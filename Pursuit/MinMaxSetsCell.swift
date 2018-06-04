//
//  MinMaxSetsCell.swift
//  Pursuit
//
//  Created by ігор on 6/1/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class MinMaxSetsCell: ConfigureSetsCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MinMaxSetsCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: "sets", with: "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text ?? "" + "sets"
    }
}
