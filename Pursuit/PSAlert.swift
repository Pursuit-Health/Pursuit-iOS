//
//  PSAlert.swift
//  Pursuit
//
//  Created by ігор on 7/9/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SimpleAlert

class PSAlert: AlertController {
    
    override func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        super.addTextField { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            
            configurationHandler?(textField)
        }
    }
    
    override func configureActionButton(_ button: UIButton, at style :AlertAction.Style) {
        super.configureActionButton(button, at: style)
        
        switch style {
        case .ok:
            button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 19)
            button.setTitleColor(UIColor.gray, for: UIControlState())
        case .cancel:
            button.backgroundColor = UIColor.darkGray
            button.setTitleColor(UIColor.white, for: UIControlState())
        case .default:
            button.setTitleColor(UIColor.lightGray, for: UIControlState())
        default:
            break
        }
    }
}
extension PSAlert {
    func addActionHandler(action: AlertAction) -> PSAlert {
        self.addAction(action)
        action.button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 19)
        return self
    }
}
