//
//  PursuitKeychain.swift
//  Pursuit
//
//  Created by ігор on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class PursuitKeychain {
    
    //MARK: Constants
    
    private struct Constants {
        struct Keys {
            static let token: String = "token"
            static let firToken: String = "firToken"
        }
    }   
    
    //MARK: Properties
    
    var service: KeychainService = KeychainAccessService()
    
    var token: String? {
        get {
            return self.service.valueForKey(key: Constants.Keys.token)
        }
        
        set(newValue) {
            self.service.setValue(value: newValue, forKey: Constants.Keys.token)
        }
    }
    
    var firToken: String? {
        get {
            return self.service.valueForKey(key: Constants.Keys.firToken)
        }
        
        set(newValue) {
            self.service.setValue(value: newValue, forKey: Constants.Keys.firToken)
        }
    }
}
