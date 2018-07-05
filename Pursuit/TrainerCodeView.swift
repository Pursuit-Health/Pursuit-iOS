//
//  TrainerCodeView.swift
//  Pursuit
//
//  Created by ігор on 7/2/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainerCodeView: BBBXIBView {
    
    var trainerCode: String? {
        didSet {
            trainerCodeLabel.text = (trainerCode ?? "").uppercased()
        }
    }
    
    @IBOutlet weak var trainerCodeLabel: CopybleLabel!
    
}
