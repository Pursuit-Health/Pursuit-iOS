//
//  DotsView.swift
//  Pursuit
//
//  Created by ігор on 12/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit


private class DotView: UIView {
    var fillColor:UIColor = .black
    var diameter:CGFloat = CGFloat(1)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        self.fillColor.setFill()
        context?.addEllipse(in: (CGRect (x: 0, y: 0, width: diameter, height: diameter)))
        context?.drawPath(using: CGPathDrawingMode.fill)
        context?.strokePath()
    }
}


class DotsView: UIView {
    
    var dotsColor:UIColor = .black
    
    var numberOfDots:NSNumber = 3
    
    var duration:NSNumber = 0.5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    fileprivate func buildView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        let numberDots = CGFloat(self.numberOfDots.floatValue)
        let width = (self.bounds.size.width)/(numberDots+1)
        let margin = (self.bounds.size.width - (width * numberDots)) / 1.3
        let dotDiameter = width/3
        var frame = CGRect(x: margin, y: self.bounds.size.height/2 - dotDiameter/2, width: dotDiameter, height: dotDiameter);
        
        for _ in 0...Int(numberDots-1) {
            let dot = DotView(frame: frame)
            dot.diameter = frame.size.width;
            dot.fillColor = self.dotsColor;
            dot.backgroundColor = .clear
            
            self.addSubview(dot)
            frame.origin.x += width
        }
    }
    
    func startAnimating() {
        buildView()
        var i:Int = 0
        for dot in self.subviews as! [DotView] {
            dot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
            let delay = 0.1*Double(i)
            UIView.animate(withDuration: Double(self.duration.doubleValue), delay:delay, options: [UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse] , animations: { () -> Void in
                dot.transform = CGAffineTransform(scaleX: 1, y: 1);
            }, completion: nil)
            
            i += 1;
        }
    }
    
    
    func stopAnimating() {
        for dot in self.subviews as! [DotView] {
            dot.transform = CGAffineTransform(scaleX: 1, y: 1);
            dot.layer.removeAllAnimations()
            dot.removeFromSuperview()
        }
    }
}
