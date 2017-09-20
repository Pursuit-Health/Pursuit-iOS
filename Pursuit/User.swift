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
    var signInName : String?
    
    func mapping(map: Map) {
        self.name            <- map["user.data.name"]
        self.email           <- map["user.data.email"]
        self.password        <- map["user.data.password"]
        self.birthday        <- map["user.data.birthday"]
        self.id              <- map["user.data.userable.data.id"]
    }
    
    init() {}
    required init?(map: Map) {
        
    }
    
    func createSignUpParameters() -> [String : String] {
        var dictionary: [String:String] = [:]
        dictionary["name"] = self.name
        dictionary["email"] = self.email
        dictionary["password"] = self.password
        dictionary["birthday"] = self.birthday
        
        return dictionary
    }
    
    //MARK: Public
    
    typealias RegisterCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    func signUp(completion: @escaping RegisterCompletion) {
        
    }
}

