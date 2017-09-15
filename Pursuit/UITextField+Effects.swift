//
//  UITextField+Effects.swift
//  Pursuit
//
//  Created by ігор on 9/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//


import UIKit

/**
 An HoshiTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable open class IMTextField: TextFieldEffects {
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
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
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 1.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y - 30 )
                self.placeholderLabel.frame = CGRect(x: 0, y: -10, width: self.placeholderLabel.bounds.width, height:self.placeholderLabel.bounds.height)
                self.placeholderLabel.configureAppearence(isSelected: true, minFontSize: self.minFontSize, maxFontSize: self.maxFontSize)
                
                //self.layoutPlaceholderInTextRect()
                //self.placeholderLabel.frame.origin = self.activePlaceholderPoint
                //self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
        //TODO: IGOR set default size of placeholderlabel
        
        
        //placeholderLabel.frame.origin = activePlaceholderPoint
        
        
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
        
        placeholderLabel.textColor = updatePlaceHolderTextColor(isActive: true)
    }
    //became inactive
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 1.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                self.placeholderLabel.configureAppearence(isSelected: false, minFontSize: self.minFontSize, maxFontSize: self.maxFontSize)
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
            
            placeholderLabel.textColor = updatePlaceHolderTextColor(isActive: false)
        }
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
        
        //placeholderLabel.frame = CGRect(origin: .init(x: originX, y: textRect.height/2), size: self.intrinsicContentSize)
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2, width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
        
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
}


