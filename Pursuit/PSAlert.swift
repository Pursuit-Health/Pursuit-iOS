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
    
    override func configureContentView(_ contentView: AlertContentView) {
        super.configureContentView(contentView)
        
        contentView.messageLabel.font = UIFont(name: "Avenir-Book", size: 13)

    }
    
    override func configureActionButton(_ button: UIButton, at style: AlertAction.Style) {
        super.configureActionButton(button, at: style)
            button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
    }
}
extension PSAlert {
    func addActionHandler(action: AlertAction) -> PSAlert {
        self.addAction(action)
        action.button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        return self
    }
}
