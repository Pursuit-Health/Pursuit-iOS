//
//  UserTypeView.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class UserTypeView: BBBXIBView {

    //MARK: IBOutlets
    
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    //MARK: Variables
  
    var isSelected: Bool = false {
        didSet {
            let selectedColor       = UIColor.white
            let nonSelectedColor    = UIColor.lightGray
            
            self.selectionView.backgroundColor = isSelected ? selectedColor : nonSelectedColor
            self.userTypeLabel.textColor       = isSelected ? selectedColor : nonSelectedColor
        }
    }
}
