//
//  PSUserDefaults.swift
//  Pursuit
//
//  Created by ігор on 5/14/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class PSUserDefaults {
    
    //MARK: Constants
    
    private struct Contsants {
        static let Weights = "weights"
    }
    
    //MARK: Properties
    
    var service: UserDefaults = UserDefaults.standard
    
    var weightsType: WeightsType? {
        get {
            let value = service.integer(forKey: Contsants.Weights)
            let type = WeightsType(rawValue: value)
            return type
        }
        set(newValue) {
            service.set(newValue?.rawValue, forKey: Contsants.Weights)
        }
    }
}
