//
//  StraightExerciseStateCell.swift
//  Pursuit
//
//  Created by Igor on 5/17/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
protocol StraightExerciseStateCellDelegate: class {
    func straightStateDidChnaged(on cell: StraightExerciseStateCell, to state: Bool)
}

class StraightExerciseStateCell: ExerciseStateCell {

    weak var delegate: StraightExerciseStateCellDelegate?
    
    override func switchChangedState(_ exSwitch: UISwitch) {
        self.delegate?.straightStateDidChnaged(on: self, to: exSwitch.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
