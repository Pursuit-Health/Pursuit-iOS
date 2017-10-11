//
//  UITextField+Effects.swift
//  Pursuit
//
//  Created by ігор on 9/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//


import UIKit
import RHDisplayLinkStepper

open class AnimatedTextField: TextFieldEffects {
    
    
    //MARK: Properties
    
    var  displayLinker = RHDisplayLinkStepper()
    
    @IBInspectable dynamic open var minFontSize: CGFloat = 17 {
        didSet {
            
        }
    }
    
    @IBInspectable dynamic open var maxFontSize: CGFloat = 17 {
        didSet {
            
        }
    }
    
    @IBInspectable dynamic open var inactiveLabelColor: UIColor? {
        didSet{
            
        }
    }
    
    @IBInspectable dynamic open var activeLabelColor: UIColor? {
        didSet {
            
        }
    }
    
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        if placeholderLabel.superview !== self {
            updateBorder()
            updatePlaceholder()
            
            layer.addSublayer(inactiveBorderLayer)
            layer.addSublayer(activeBorderLayer)
            addSubview(placeholderLabel)
        }
    }
    
    override open func animateViewsForTextEntry() {
//        if text?.isEmpty ?? true {
//            UIView.animate(withDuration: 1.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
//
//            }), completion: { _ in
//                self.animationCompletionHandler?(.textEntry)
//            })
//        }
        let multiplier = self.minFontSize / self.maxFontSize
        if text?.isEmpty ?? true {
            animatelabelfont(from: 1, to: multiplier)
        }
        
        placeholderLabel.textColor = updatePlaceHolderTextColor(isActive: true)
    }
    
    override open func animateViewsForTextDisplay() {
//            UIView.animate(withDuration: 1.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
//
//            }), completion: { _ in
//                self.animationCompletionHandler?(.textDisplay)
//            })
            let multiplier = self.minFontSize / self.maxFontSize
            
            if text?.isEmpty ?? true {
                animatelabelfont(from: 1, to: 1/multiplier)
            }
            //activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
            
            placeholderLabel.textColor = updatePlaceHolderTextColor(isActive: false)
    }
    
    // MARK: - Private
    
    private func updatePlaceHolderTextColor(isActive: Bool) -> UIColor {
        return isActive ? (activeLabelColor ?? .white) : (inactiveLabelColor ?? .white)
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            placeholderLabel.textColor = .green
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            placeholderLabel.textColor = .red
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        if self.text?.isEmpty ?? true {
            placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2, width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        } else {
            placeholderLabel.frame = CGRect(x: originX, y: 0, width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        }
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
    }
    
     private func animatelabelfont(from: CGFloat, to: CGFloat) {
        let frame = self.placeholderLabel.frame
        self.placeholderLabel.adjustsFontSizeToFitWidth = true
        
        self.displayLinker.step(from: from, to: to, withDuration: 0.2) { (progress) in
            let multiplier: CGFloat = from > to ? 1 : -1
            let y = frame.origin.y - (from - progress) / (from - to) * 10 * multiplier
            self.placeholderLabel.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width * progress, height: frame.size.height * progress)
        }
    }
    
    func animatelabelfontQuick(from: CGFloat, to: CGFloat) {
        let frame = self.placeholderLabel.frame
        self.placeholderLabel.adjustsFontSizeToFitWidth = true
        
        self.displayLinker.step(from: from, to: to, withDuration: 0) { (progress) in
            let multiplier: CGFloat = from > to ? 1 : -1
            let y = frame.origin.y - (from - progress) / (from - to) * 10 * multiplier
            self.placeholderLabel.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width * progress, height: frame.size.height * progress)
        }
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
}


