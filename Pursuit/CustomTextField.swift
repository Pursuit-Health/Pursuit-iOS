//
//  CustomTextField.swift
//  Pursuit
//
//  Created by ігор on 8/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    fileprivate let searchImageLength: CGFloat = 22
    fileprivate let cancelButtonLength: CGFloat = 15
    fileprivate let padding: CGFloat = 8
    
    
    override init( frame: CGRect ) {
        super.init( frame: frame )
        self.customLayout()
    }
    
    required init?( coder aDecoder: NSCoder ) {
        super.init( coder: aDecoder )
        self.customLayout()
    }
    
    override func leftViewRect( forBounds bounds: CGRect ) -> CGRect {
        let x = self.padding
        let y = ( bounds.size.height - self.searchImageLength ) / 2
        let rightBounds = CGRect( x: x, y: y, width: self.searchImageLength, height: self.searchImageLength )
        return rightBounds
    }
    
    override func rightViewRect( forBounds bounds: CGRect ) -> CGRect {
        let x = bounds.size.width - self.cancelButtonLength - self.padding
        let y = ( bounds.size.height - self.cancelButtonLength ) / 2
        let rightBounds = CGRect( x: x, y: y, width: self.cancelButtonLength, height: self.searchImageLength )
        return rightBounds
    }
    
    fileprivate func customLayout() {
        let clearButton = UIButton()
        clearButton.setImage( UIImage( named: "search" ), for: .normal )
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget( self, action: #selector( self.searchClicked ), for: .touchUpInside )
        self.rightView = clearButton
        self.clearButtonMode = .never
        self.rightViewMode = .always
    }
    
    @objc fileprivate func searchClicked( sender: UIButton ) {
      
    }
}
