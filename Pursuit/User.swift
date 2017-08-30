//
//  User.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    class PersonalData: Mappable {
        
        //MARK: Properties
        
        var userAccount         : String?
        var email               : String?
        var password            : String?
        var gender              : String?
        var birthday            : String?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.userAccount     <- map["account"]
            self.email           <- map["email"]
            self.password        <- map["password"]
            self.gender          <- map["gender"]
            self.birthday        <- map["birthday"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
    
    //MARK: Properties
    
    var signUpData = PersonalData()
    
    //MARK: Mappable
    
    var email    : String?
    var status   : String?
    var message  : String?
    
    func mapping(map: Map) {
        self.email      <- map["email"]
        self.status     <- map["status"]
        self.message    <- map["message"]
    }
    
    required init?(map: Map) {
        
    }
}
