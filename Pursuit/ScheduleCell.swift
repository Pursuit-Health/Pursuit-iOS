//
//  ScheduleCell.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class ScheduleCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var clientsCountLabel: UILabel!
    @IBOutlet weak var imagesStackView: UIStackView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //TODO: Find Grater solution/Use stackView instead
    func fillImages(clients: [Client]) {
        
        if clients.count >= 3 {
            if let url = clients[0].clientAvatar {
                firstImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                firstImageView.image = UIImage(named: "profile")
            }
            
            if let url = clients[1].clientAvatar {
                secondImageView.sd_setImage(with: URL(string:  url.persuitImageUrl()))
            }else {
                secondImageView.image = UIImage(named: "profile")
            }
            if let url = clients[2].clientAvatar {
                thirdImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                thirdImageView.image = UIImage(named: "profile")
            }
            if clients.count == 3 {
                clientsCountLabel.text = ""
            }else {
                clientsCountLabel.text = "+" + "\(clients.count - 3)"
            }
            
        }else if clients.count == 2 {
            
            if let url = clients[0].clientAvatar {
                secondImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                secondImageView.image = UIImage(named: "profile")
            }
            if let url = clients[1].clientAvatar {
                thirdImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                thirdImageView.image = UIImage(named: "profile")
            }
            
            clientsCountLabel.text = ""
        }else if clients.count == 1 {
            
            if let url = clients[0].clientAvatar {
                thirdImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
            }else {
                thirdImageView.image = UIImage(named: "profile")
            }
            
            clientsCountLabel.text = ""
        }
    }
    
}
