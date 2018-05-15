//
//  UserSettings.swift
//  Pursuit
//
//  Created by ігор on 5/15/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class UserSettings {
    
    //MARK: Init
    
    private init() { }
    
    //MARK: Shared
    
    static var shared = UserSettings()
    
    //MARK: Private
    
    private let psDefaults = PSUserDefaults()
    
    //MARK: Public
    
    public var weightsType: WeightsType {
        get {
            return psDefaults.weightsType ?? .lbs
        }
        set (newValue) {
            psDefaults.weightsType = newValue
        }
    }
}
