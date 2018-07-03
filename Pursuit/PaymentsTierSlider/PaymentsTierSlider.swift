//
//  PaymentsTierSlider.swift
//  Pursuit
//
//  Created by ігор on 7/3/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class PaymentsTierSlider: UISlider {
        
        override func trackRect(forBounds bounds: CGRect) -> CGRect {

            let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 10.0))
            super.trackRect(forBounds: customBounds)
            return customBounds
        }
    
        override func awakeFromNib() {
            //self.setThumbImage(UIImage(named: "customThumb"), for: .normal)
            super.awakeFromNib()
        }

}
