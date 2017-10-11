//
//  SignUpDataCell.swift
//  Pursuit
//
//  Created by Igor on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SignUpDataCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var userDataTextField: AnimatedTextField!
    @IBOutlet weak var cellImageview: UIImageView!
    
    func datePicker() -> UIDatePicker {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        
        datePickerView.addTarget(self, action: #selector(SignUpDataCell.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return datePickerView
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        userDataTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
}
