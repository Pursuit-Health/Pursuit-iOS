//
//  CellState.swift
//  Pursuit
//
//  Created by ігор on 8/29/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CellState {
    
    func handleCellTextColor(cell: CalendarCell) {
        let myCustomCell = cell
        
        if self.isSelected {
            myCustomCell.dateLabel.textColor = UIColor.white
        } else {
            myCustomCell.dateLabel.textColor = (self.dateBelongsTo == .thisMonth) ? .white : .gray
        }
    }
    
    func handleSpecialDates(cell: CalendarCell, specialDates: [String], formatter: DateFormatter){
        cell.isSpecialDate = specialDates.contains(formatter.string(from: self.date))
        print(formatter.string(from: self.date))
        print(cell.isSpecialDate)
    }
    
    func handleCellSelection(cell: CalendarCell) {
        let myCustomCell = cell
        
        if self.isSelected {
            myCustomCell.bgView.clipsToBounds           = true
            myCustomCell.bgView.isHidden                = false
            
            myCustomCell.bgView.backgroundColor         = UIColor.clear
            myCustomCell.bgView.layer.borderWidth       = 1.0
            myCustomCell.bgView.layer.borderColor       = UIColor.cellSelection().cgColor
        } else {
            myCustomCell.bgView.isHidden                = true
        }
    }
}

extension CellState {
    func handleCellTextColor(cell: CreateTemplateCalendarCell) {
        let myCustomCell = cell
        

    }

    func templateCalendarCellselected(cell: CreateTemplateCalendarCell) {
        
        var backGroundColor = UIColor()
        var weekColor = UIColor()
        var monthdayColor = UIColor()
        if self.isSelected {
            monthdayColor = UIColor.white
            weekColor = UIColor.white
            backGroundColor = UIColor.customAuthButtons()
            
        }else {
             backGroundColor = UIColor.clear
            monthdayColor = UIColor.white
            weekColor = UIColor.lightGray
        }
        cell.backGroundView.backgroundColor = backGroundColor
        cell.weekDayLabel.textColor = weekColor
        cell.monthDayLabel.textColor = monthdayColor
    }
}
