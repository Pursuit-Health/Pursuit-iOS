//
//  ExerciseStateCell.swift
//  Pursuit
//
//  Created by Igor on 5/16/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import JTMaterialSwitch

class ExerciseStateCell: UITableViewCell {
    
    //MARK: IBOutlets
    var stateSwitch: JTMaterialSwitch?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchContainerView: UIView! {
        didSet {
            stateSwitch = JTMaterialSwitch()
            stateSwitch?.addTarget(self, action: #selector(switchChangedState(_:)), for: .valueChanged)
            stateSwitch?.thumbOnTintColor = UIColor.customGreenColor()
            stateSwitch?.thumbOffTintColor = UIColor.customGreenColor()
            
            stateSwitch?.trackOnTintColor = UIColor.init(red: 48/255, green: 213/255, blue: 200/255, alpha: 0.7)
            stateSwitch?.trackOffTintColor = UIColor.white//UIColor.init(red: 48/255, green: 213/255, blue: 200/255, alpha: 0.7)
            stateSwitch?.isBounceEnabled = true
            switchContainerView.addSubview(stateSwitch ?? UIView())
            switchContainerView.addConstraints(UIView.place(stateSwitch, onOtherView: switchContainerView))
        }
    }
    
    @objc func switchChangedState(_ exSwitch: UISwitch) {
       
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
