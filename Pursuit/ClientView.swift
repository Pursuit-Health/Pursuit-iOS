//
//  ClientView.swift
//  Pursuit
//
//  Created by ігор on 7/17/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ClientView: BBBXIBView {

    
    
    @IBOutlet weak var clientAvatarImageView: UIImageView! {
        didSet {
            clientAvatarImageView.layer.cornerRadius = clientAvatarImageView.bounds.height / 2
            clientAvatarImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var clientNameLabel: UILabel!
    
    
    var avatar: String?{
        didSet {
            if let url = avatar {
           clientAvatarImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                clientAvatarImageView.image = UIImage(named: "profile")
            }
        }
    }
    
    var name: String? {
        didSet {
           clientNameLabel.text = name
        }
    }
}
