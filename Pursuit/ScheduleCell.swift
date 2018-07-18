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

    func fillImages(clients: [Client]) {
        for view in imagesStackView.subviews {
            view.removeFromSuperview()
        }
        for (index, client) in clients.enumerated() {
            
            if clients.count <= 3 {
                clientsCountLabel.text = ""
            }else {
                clientsCountLabel.text = "+" + "\(clients.count - 3)"
            }
            
            if index > 2 {
                return
            }
            
            let clientView = ClientView()
            clientView.name = client.name
            clientView.avatar = client.clientAvatar 
            clientView.translatesAutoresizingMaskIntoConstraints = false
            clientView.heightAnchor.constraint(equalToConstant: 45).isActive = true
            clientView.widthAnchor.constraint(equalToConstant: 35).isActive = true
            imagesStackView.addArrangedSubview(clientView)
        }
    }
}
