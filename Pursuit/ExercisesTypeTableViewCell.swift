//
//  ExercisesTypeTableViewCell.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExercisesTypeTableViewCellDelegate: class {
    func tappedOn(_ cell: ExercisesTypeTableViewCell, with type: ExcersiseData.ExcersiseType)
}

class ExercisesTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var excersiseTypeView: ExercisesTypeView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: Variables
    
    weak var delegate: ExercisesTypeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     }
}

extension ExercisesTypeTableViewCell: ExercisesTypeViewDelegate {
    func tappedOn(_ view: ExercisesTypeView, with type: ExcersiseData.ExcersiseType) {
        self.delegate?.tappedOn(self, with: type)
        
    }
}
