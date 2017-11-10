//
//  ClientInfoCell.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ClientInfoCellDelegate: class {
    func didTappedOnImage(cell: ClientInfoCell)
}
class ClientInfoCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var templateNameLabel: UILabel!
    @IBOutlet weak var clientPhotoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: Variables
    
    var delegate: ClientInfoCellDelegate?
    
    var selectedCell: Bool = false {
        didSet {
            let image = UIImage(named: selectedCell ? "check_mark_color" : "")
            self.clientPhotoImageView.image = image
            self.clientPhotoImageView.layer.borderWidth = selectedCell ? 0 : 1
        }
    }
    
    //MARK: IBActions
    
    @IBAction func didTapOnImage(_ sender: Any) {
        self.delegate?.didTappedOnImage(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
