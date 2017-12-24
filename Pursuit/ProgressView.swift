//
//  ProgressView.swift
//  Pursuit
//
//  Created by ігор on 12/23/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
     func show(on superview: UIView) {
    
        self.frame.size.height = 50
        self.frame.size.width = 50
        self.center = superview.center
        self.backgroundColor = .clear
        
        superview.addSubview(self)

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = self.bounds
        
        replicatorLayer.instanceCount = 30
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 30.0)
        replicatorLayer.preservesDepth = false
        replicatorLayer.instanceColor = UIColor.white.cgColor
        
//        replicatorLayer.instanceRedOffset = 0.0
//        replicatorLayer.instanceGreenOffset = -0.5
//        replicatorLayer.instanceBlueOffset = -0.5
//        replicatorLayer.instanceAlphaOffset = 0.0
        
        replicatorLayer.instanceColor = UIColor.init(red: 80/255, green: 250/255, blue: 150/155, alpha: 1).cgColor
        
        let angle = Float(Double.pi * 2.0) / 30
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        self.layer.addSublayer(replicatorLayer)
        
        
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 5.0
        let midX = self.bounds.midX - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        replicatorLayer.addSublayer(instanceLayer)
        
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        instanceLayer.opacity = 0.0
        instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
    }
    
     func dissmiss(form superView: UIView) {
       self.removeFromSuperview()
    }

}
