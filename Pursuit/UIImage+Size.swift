//
//  UIImage+Size.swift
//  Pursuit
//
//  Created by Igor on 6/15/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

extension UIImage {
    func compressTo(_ maxByte: Int) -> Data? {
        
        var compressQuality: CGFloat = 1
        var imageByte = UIImageJPEGRepresentation(self, 1)?.count
        
        while imageByte! > maxByte {
            
            imageByte = UIImageJPEGRepresentation(self, compressQuality)?.count
            compressQuality -= 0.1
            
        }
        return UIImageJPEGRepresentation(self, compressQuality)
    }
}
