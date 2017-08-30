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
    
    func handleSpecialDates(cell: CalendarCell, specialDates: [String:String], formatter: DateFormatter){
        cell.isSpecialDate = specialDates.contains {$0.key == formatter.string(from: self.date)}
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
