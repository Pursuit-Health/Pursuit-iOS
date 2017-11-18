//
//  ExercisesTypeCollectionViewCell.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExercisesTypeCollectionViewCellDelegate: class {
    func tappedOn(_ cell: ExercisesTypeCollectionViewCell)
}

class ExercisesTypeCollectionViewCell: UICollectionViewCell {

    //MARK: Variables
    weak var delegate: ExercisesTypeCollectionViewCellDelegate?
    
    var typeSelected: Bool = false {
        didSet {
            let bordercolor = self.typeSelected ? UIColor.customAuthButtons() : UIColor.exerciseTypeRedColor()
            let titlecolor = self.typeSelected ? UIColor.white : UIColor.exerciseTypeRedColor()
            let backGroundColor = self.typeSelected ? UIColor.customAuthButtons() : UIColor.clear
            exerciseTypeButton.setTitleColor(titlecolor, for: .normal)
            exerciseTypeButton.layer.borderColor =  bordercolor.cgColor
            exerciseTypeButton.backgroundColor = backGroundColor
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var exerciseTypeButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBAction func exercisesTypeButtonPressed(_ sender: Any) {
        self.delegate?.tappedOn(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
