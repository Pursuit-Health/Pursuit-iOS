//
//  ExercisesTypeTableViewCell.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExercisesTypeTableViewCellDelegate: class {
    func tappedOn(_ cell: ExercisesTypeTableViewCell, with type: ExerciseType)
}

class ExercisesTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    var view = ExercisesTypeView()
    
    //MARK: Variables
    
    weak var delegate: ExercisesTypeTableViewCellDelegate?
    
     func configureCell(with type: [ExerciseType]) {
        view.configureCell(with: type)
        view.delegate = self
        self.mainView.addSubview(self.view)
        self.mainView.addConstraints(UIView.place(self.view, onOtherView: self.mainView))
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

extension ExercisesTypeTableViewCell: ExercisesTypeViewDelegate {
    func tappedOn(_ view: ExercisesTypeView, with type: ExerciseType) {
        self.delegate?.tappedOn(self, with: type)
        
    }
}
