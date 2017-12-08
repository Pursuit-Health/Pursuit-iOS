//
//  ChatVC.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = ""
        self.senderDisplayName = "Client"
        
        configureInputMessageBar()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Private
    
    private func configureInputMessageBar() {
        self.inputToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        self.inputToolbar.contentView.rightBarButtonItem.titleLabel?.font = UIFont(name: "Avenir", size: 17.0)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("SEND", for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        self.inputToolbar.contentView.rightBarButtonItem.setTitleColor(.white, for: .normal)
        

        self.inputToolbar.contentView.leftBarButtonItem.setImage(UIImage(named: "addMessage"), for: .normal)
        
        self.inputToolbar.contentView.textView.backgroundColor = .clear
        self.inputToolbar.contentView.textView.layer.borderWidth = 0.0
        self.inputToolbar.contentView.textView.changePlaceHolderText("Your message")
        self.inputToolbar.contentView.textView.changeFont(UIFont(name: "Avenir", size: 17.0))
        
        self.collectionView.backgroundColor = .clear
    }
}
