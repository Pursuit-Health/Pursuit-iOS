//
//  SelectClientCell.swift
//  Pursuit
//
//  Created by ігор on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SelectClientCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var clientNameLabel      : UILabel!
    @IBOutlet weak var clientPhotoImageView : UIImageView!
    @IBOutlet weak var selectedView         : UIView! {
        didSet {
            self.selectedView.isHidden = true
        }
    }
    
    //MARK: Variables
    
    var clientSelected: Bool = false {
        didSet {
            self.selectedView.isHidden = !self.clientSelected
            //self.selectedView.backgroundColor = self.clientSelected ? setColorWithAlpha() : setClearColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setColorWithAlpha() -> UIColor {
        return UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    private func setClearColor() -> UIColor {
        return UIColor.clear
    }
    
}
