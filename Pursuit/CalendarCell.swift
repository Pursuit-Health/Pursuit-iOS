//
//  CalendarCell.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/30/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    
    //MARK: IBOutlets
    
    //TODO: Why outlets not weak? 
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var specialDatesView: UIView!
    
    //MARK: Public
    
    var isSpecialDate: Bool = true {
        didSet{
           specialDatesView.isHidden = isSpecialDate
        }
    }
    
}
