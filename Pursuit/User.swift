//
//  User.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    //MARK: Private.Properties
    
    static var token: String? {
        get {
            let keychain        = PursuitKeychain()
            return keychain.token
        }
        set(newValue) {
            let keychain        = PursuitKeychain()
            keychain.token      = newValue
        }
    }
    
    //MARK: Mappable
    
    var id                  : Int?
    var name                : String?
    var email               : String?
    var password            : String?
    var birthday            : String?
    var token               : String?
    var avatar              : String?
    
    func mapping(map: Map) {
        self.name            <- map["data.name"]
        self.email           <- map["data.email"]
        self.password        <- map["data.password"]
        self.birthday        <- map["data.birthday"]
        self.token           <- map["meta.token"]
    }
    
    init() {}
    required init?(map: Map) {
        
    }
}

