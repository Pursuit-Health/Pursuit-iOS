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
    
    var personalData    : PersonalData?
    var metaData        : MetaData?
    var trainersData    : [TrainersData]?
    
    func mapping(map: Map) {
        self.personalData         <- map["data"]
        self.metaData             <- map["meta"]
        self.trainersData         <- map["data"]
    }
    
    required init?(map: Map) {
        
    }
    
    class PersonalData: Mappable {
        
        //MARK: Properties
        
        var name               : String?
        var email              : String?
        var password           : String?
        var birthday           : String?
        
        var id                 : Int?
        var userable           : PersonalData?
        var userableData       : PersonalData?
        
        var trainerId           : Int?
        
        
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
        var token                  : String?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.userType         <- map["user_type"]
            self.token            <- map["token"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
    
    class TrainersData: Mappable {
        var id: Int?
        var user: TrainersData?
        var data: TrainersData?
        var name: String?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.id              <- map["id"]
            self.user            <- map["user"]
            self.data            <- map["data"]
            self.name            <- map["name"]
          
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
}

