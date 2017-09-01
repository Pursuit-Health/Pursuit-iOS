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
        
        var name               : String?
        var email              : String?
        var password           : String?
        var birthday           : String?
        
        var id                 : Int?
        var userable           : PersonalData?
        var userableData       : PersonalData?
        
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.name            <- map["name"]
            self.email           <- map["email"]
            self.password        <- map["password"]
            self.birthday        <- map["birthday"]
            self.id              <- map["id"]
            self.userable        <- map["userable"]
            self.userableData    <- map["data"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
    
    class MetaData: Mappable {
        
        var userType               : String?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.userType         <- map["user_type"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
 
        //MARK: Mappable
    
    var personalData    : PersonalData?
    var metaData        : MetaData?

    
    func mapping(map: Map) {
        self.personalData         <- map["data"]
        self.metaData             <- map["meta"]
    }
    
    required init?(map: Map) {
        
    }
}

