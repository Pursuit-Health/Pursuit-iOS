//
//  SendeMessageWithImageCell.swift
//  Pursuit
//
//  Created by ігор on 12/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SendeMessageWithImageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messagePhoto: UIImageView! {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.fillColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0).cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        self.messagePhoto.layer.mask = shapeLayer
        //layer.addSublayer(shapeLayer)
    }
    
    
    func createBezierPath() -> UIBezierPath {
        
        let width = messagePhoto.bounds.maxX
        let height = messagePhoto.bounds.maxY
        
        let path = UIBezierPath()
        
        
        path.move(to: CGPoint(x: messagePhoto.bounds.minX, y: messagePhoto.bounds.minY))
        
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
