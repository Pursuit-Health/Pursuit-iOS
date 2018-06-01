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
        
        datePickerView.maximumDate = Date()
        
        let locale: Locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        datePickerView.locale = locale
        
        datePickerView.addTarget(self, action: #selector(SignUpDataCell.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return datePickerView
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        let locale: Locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        dateFormatter.locale = locale
        
        userDataTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
}
