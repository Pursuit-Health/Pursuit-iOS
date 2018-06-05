//
//  TodoubleTransform.swift
//  Pursuit
//
//  Created by Igor on 6/5/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class DoubleTransform: TransformType {
    
    //MARK: Variables
    
    var multiplier: Double = 1000
    
    //MARK: TransformType
    
    func transformToJSON(_ value: Double?) -> Int? {
        if let double = value {
           return Int(double * multiplier)
        }
        return  nil
    }
    
    public typealias Object = Double
    public typealias JSON = Int
    
    init(multiplier: Double = 1000) {
        self.multiplier = multiplier
    }
    
    open func transformFromJSON(_ value: Any?) -> Double? {
        guard let intObj = value as? Int else { return nil }
        return Double(intObj) / multiplier
    }
}

