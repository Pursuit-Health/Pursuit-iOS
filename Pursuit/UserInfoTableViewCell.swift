//
//  UserInfoTableViewCell.swift
//  Pursuit
//
//  Created by Igor on 5/14/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

protocol UserInfoTableViewCellDelegate: class {
    func userDidPressedChangePhoto(on cell: UserInfoTableViewCell)
}

class UserInfoTableViewCell: UITableViewCell {
    
    //MARK: Variables
    
    weak var delegate: UserInfoTableViewCellDelegate?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    //MARK: IBActions
    
    @IBAction func changePhofilePhotoButtonPressed(_ sender: Any) {
       self.delegate?.userDidPressedChangePhoto(on: self)
    }
    
    //MARK: Configure
    
    func configureWith(user: User) {
        userNameLabel.text = User.shared.name ?? ""
        userEmailLabel.text = User.shared.email ?? ""
        if let avatar = User.shared.avatar {
            DispatchQueue.main.async {
                self.userPhotoImageView.sd_setImage(with: URL(string:  PSURL.BasePhotoURL + avatar))
            }
        }
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
