//
//  MaskView.swift
//  Pursuit
//
//  Created by ігор on 12/8/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class MaskView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setup()
    }
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.fillColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    
    func createBezierPath() -> UIBezierPath {
        
        let width = bounds.maxX
        let height = bounds.maxY
        
        let path = UIBezierPath()
        
        
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        
        path.addLine(to: CGPoint(x: width, y: 0))
        
        path.addLine(to: CGPoint(x: width, y: height))
        
        path.addArc(withCenter: CGPoint(x: height, y: 0),
                    radius: height,
                    startAngle: CGFloat(M_PI/2),
                    endAngle: CGFloat(-M_PI/2),
                    clockwise: true)
        
        path.close() // draws the final line to close the path
        
        return path
    }

}
