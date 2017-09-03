//
//  PursuitKeychain.swift
//  Pursuit
//
//  Created by Igor on 9/3/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

protocol KeychainService {
    func valueForKey(key: String) -> String?
    func setValue(value: String?, forKey key: String)
}
