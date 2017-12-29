//
//  SameMessageTextCell.swift
//  Pursuit
//
//  Created by ігор on 12/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SameMessageTextCell: UITableViewCell {

    @IBOutlet weak var talesView: UIView! {
        didSet {
            self.talesView.layer.masksToBounds = true
            setup()
        }
    }
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
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
        
        talesView.layer.addSublayer(shapeLayer)
    }
    
    
    func createBezierPath() -> UIBezierPath {
        
        let width = talesView.bounds.maxX
        let height = talesView.bounds.maxY
        
        let path = UIBezierPath()
        
        
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        
        
        path.addArc(withCenter: CGPoint(x: width, y: 0),
                    radius: width,
                    startAngle: CGFloat(M_PI),
                    endAngle: CGFloat(M_PI/2),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: height))

        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.close()
        
        return path
    }

}
