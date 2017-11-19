//
//  CalendarViewCell.swift
//  Pursuit
//
//  Created by ігор on 11/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CreateTemplateCalendarCell: JTAppleCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var monthDayLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
