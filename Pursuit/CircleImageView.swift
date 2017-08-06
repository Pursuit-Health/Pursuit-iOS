//
//  CircleImageView.swift
//  Pursuit
//
//  Created by ігор on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCornerRadius()
    }
    
    private func setUpCornerRadius(){
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}
