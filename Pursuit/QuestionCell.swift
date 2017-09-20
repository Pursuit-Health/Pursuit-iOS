//
//  QuestionCell.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate: class {
    func isTrainer(_ isTrainer: Bool, on cell: QuestionCell)
}

class QuestionCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var trainerNotSelectedView: UserTypeView! {
        didSet {
            self.trainerNotSelectedView.isSelected = false
            self.trainerNotSelectedView.userTypeLabel.text = "No"
        }
    }
    @IBOutlet weak var trainerIsSelectedView: UserTypeView! {
        didSet {
            self.trainerIsSelectedView.isSelected = true
            self.trainerIsSelectedView.userTypeLabel.text = "Yes"
        }
    }
    
    //MARK: Variables 
    
    weak var delegate: QuestionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestures()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: Private 
    
    private func addGestures() {
        let tapForSelecttedtrainer      = UITapGestureRecognizer(target: self,
                                                                 action: #selector( selectTrainer(_:)))
        let tapForNotSelectedtrainer    = UITapGestureRecognizer(target: self,
                                                                 action: #selector( deselctTrainer(_:)))
        
        tapForNotSelectedtrainer.delegate   = self
        tapForSelecttedtrainer.delegate     = self
        
        self.trainerIsSelectedView.addGestureRecognizer(tapForSelecttedtrainer)
        self.trainerNotSelectedView.addGestureRecognizer(tapForNotSelectedtrainer)
    }
    
    @objc private func selectTrainer(_ gesture: UITapGestureRecognizer) {
        self.trainerIsSelectedView.isSelected = true
        self.trainerNotSelectedView.isSelected = false
        delegate?.isTrainer(true, on: self)
    }
    
    @objc private func deselctTrainer(_ gesture: UITapGestureRecognizer) {
        self.trainerIsSelectedView.isSelected = false
        self.trainerNotSelectedView.isSelected = true
        delegate?.isTrainer(false, on: self)
    }
    
}
