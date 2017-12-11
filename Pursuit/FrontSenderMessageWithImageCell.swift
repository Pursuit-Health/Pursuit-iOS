//
//  FrontSenderWithImageCell.swift
//  Pursuit
//
//  Created by ігор on 12/8/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class FrontSenderMessageWithImageCell: UITableViewCell {
    @IBOutlet weak var messageLabe: UILabel!
    
    @IBOutlet weak var sendPhotoImageView: UIImageView! {
        didSet {
            self.setup()
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
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.fillColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        self.sendPhotoImageView.layer.mask = shapeLayer
        //layer.addSublayer(shapeLayer)
    }
    
    
    func createBezierPath() -> UIBezierPath {
        
        let width = sendPhotoImageView.bounds.maxX
        let height = sendPhotoImageView.bounds.maxY
        
        let path = UIBezierPath()
        
        
        path.move(to: CGPoint(x: sendPhotoImageView.bounds.minX, y: sendPhotoImageView.bounds.minY))
        
        path.addArc(withCenter: CGPoint(x: 20, y: 0),
                    radius: 20,
                    startAngle: CGFloat(M_PI),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: 20))
        
        path.addArc(withCenter: CGPoint(x: width - 20, y: 40),
                    radius: 20,
                    startAngle: CGFloat(-M_PI/2),
                    endAngle: CGFloat(0),
                    clockwise: true)
        path.addArc(withCenter: CGPoint(x: width - 20, y: height - 20),
                    radius: 20,
                    startAngle: CGFloat(0),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: true)
        path.addArc(withCenter: CGPoint(x: 20, y: height - 20),
                    radius: 20,
                    startAngle: CGFloat(M_PI/2),
                    endAngle: CGFloat(M_PI),
                    clockwise: true)
    

        path.close() // draws the final line to close the path
        
        return path
    }
    
}
