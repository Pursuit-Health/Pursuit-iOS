//
//  PSActionSheet.swift
//  Pursuit
//
//  Created by Igor on 5/22/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SimpleAlert

class PSActionSheet: AlertController {
    
    override func configureContentView(_ contentView: AlertContentView) {
        super.configureContentView(contentView)
        
        contentView.titleLabel.textColor = UIColor.lightGray
        contentView.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        contentView.messageLabel.textColor = UIColor.lightGray
        contentView.messageLabel.font = UIFont(name: "Avenir-Book", size: 15)
//        contentView.textBackgroundView.layer.cornerRadius = 10.0
//        contentView.textBackgroundView.clipsToBounds = true
    }
}

extension PSActionSheet {
     func addAction(action: AlertAction) -> PSActionSheet {
        self.addAction(action)
        action.button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 19)
        return self
    }
}
