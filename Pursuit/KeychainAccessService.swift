//
//  PursuitKeychain.swift
//  Pursuit
//
//  Created by Igor on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import KeychainAccess

class KeychainAccessService: KeychainService {
    
    //MARK: KeychainService
    
    func valueForKey(key: String) -> String? {
        return self.keychain[key]
    }
    
    func setValue(value: String?, forKey key: String) {
        self.keychain[key] = value
    }
    
    //MARK: Private.Property
    
    private lazy var service: String = {
        return Bundle.main.bundleIdentifier ?? "pursuit"
    }()
    
    private lazy var keychain: Keychain = {
        return Keychain(service: self.service)
    }()
    
}
