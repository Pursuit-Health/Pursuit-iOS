//
//  RoundedSegmentedControl.swift
//  Pursuit
//
//  Created by Igor on 5/14/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

//TODO: Need refactoring
import UIKit

@IBDesignable class RoundedSegmentedControl: UIControl {
    
    //MARK: Public
    
    public var animationDuration: Double = 0.35
    
    public var thumbSize = CGSize(width: 16.0, height: 16.0)
    
    public var onTintColor = UIColor.customGreenColor()
    
    public var thumbCornerRadius: CGFloat = 10.0
    
    public var offTintColor = UIColor.white
    
    public var padding: CGFloat = 0.0
    
    public var items: [String] = [] {
        didSet {
            setupLabels()
        }
    }
    
    public var selectedSegmentIndex: Int = 0
    
    //MARK: Fileprivate
    
    fileprivate var labels: [UILabel] = []
    
    fileprivate var thumbView = UIView()
    
    fileprivate var onPoint = CGPoint.zero
    
    fileprivate var offPoint = CGPoint.zero
    
    fileprivate var isAnimating = false
    
    var isOn: Bool {
        return selectedSegmentIndex == 1
    }
    
    //MARK: -   Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
}

extension RoundedSegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setUpUI()
        
        displaySelectedIndex()
        
        if !isAnimating {
            let yPostition = (bounds.size.height - thumbSize.height) / 2
            
            onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPostition)
            offPoint = CGPoint(x: padding, y: yPostition)
            
            thumbView.frame = CGRect(origin: isOn ? onPoint : offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbCornerRadius
        }
    }
    
    //MARK: -   Touch tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) && index != selectedSegmentIndex {
                selectedSegmentIndex = index
                break
            }
        }
        animate()
        return true
    }
}

private extension RoundedSegmentedControl {
    
    func setUpUI() {
        let newWidth = bounds.width / CGFloat(items.count)
        let selectFrame = CGRect(x: CGFloat(selectedSegmentIndex) * newWidth, y: bounds.minY, width: newWidth, height: bounds.height)
        
        thumbView.frame = selectFrame
        thumbView.backgroundColor = UIColor.customGreenColor()
        thumbView.layer.cornerRadius = 10
        
        let labelHeight = bounds.height
        let labelWidth = bounds.width / CGFloat(labels.count)
        
        for index in 0..<labels.count {
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition - 1, y: 0, width: labelWidth + 2, height: labelHeight)
        }
    }
    func setupView() {
        backgroundColor = .clear
        clipsToBounds = false
        thumbSize = thumbView.frame.size
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        for (index, item) in items.enumerated() {
            let label = UILabel(frame: CGRect.zero)
            label.text = item
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = index == selectedSegmentIndex ? UIColor.white : UIColor.red
            
            labels.append(label)
            
            addSubview(label)
        }
    }
    
    func displaySelectedIndex() {
        for (index,label) in labels.enumerated() {
            if index == selectedSegmentIndex {
                label.textColor = .white
                thumbSize       = label.frame.size
            } else {
                label.textColor = .red
            }
        }
    }
    
    func animate() {
        isAnimating = true
        displaySelectedIndex()
        UIView.animate(withDuration: animationDuration, delay: 0, options: [UIViewAnimationOptions.curveEaseOut,
                                                             UIViewAnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x

        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControlEvents.valueChanged)
        })
    }
}
