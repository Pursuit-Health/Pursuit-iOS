//
//  ExerciseCell.swift
//  Pursuit
//
//  Created by ігор on 11/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate: class {
    func didTappedOnImage(cell: ExerciseCell)
}

class ExerciseCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    //MARK: Variables
    
    var delegate: ExerciseCellDelegate?
    
    var selectedCell: Bool = false {
        didSet {
            let image = UIImage(named: selectedCell ? "oval_check_mark" : "")
            self.checkMarkImageView.image = image
            self.checkMarkImageView.layer.borderColor = selectedCell ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
        }
    }
    
    //MARK: IBActions
    
    @IBAction func didTapOnImage(_ sender: Any) {
        self.delegate?.didTappedOnImage(cell: self)
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
