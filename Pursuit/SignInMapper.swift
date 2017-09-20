//
//  SignInMapper.swift
//  Pursuit
//
//  Created by ігор on 9/20/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class SignInMapper: Mappable {
    
    //MARK: Nested
    
    class Data: Mappable {
        
        //MARK: Nested
        
        class SimpleData: Mappable {
            
            var id:         Int?
            
            func mapping(map: Map) {
                self.id      <- map["data.id"]
            }
            
            init() {}
            required init?(map: Map) {
                
            }
        }
        
        //MARK: Variables
        
        var id          : Int?
        var name        : String?
        var email       : String?
        var avatar      : String?
        var birthday    : String?
        var userable    : SimpleData?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            
            self.id                     <- map["id"]
            self.name                   <- map["name"]
            self.email                  <- map["email"]
            self.avatar                 <- map["avatar"]
            self.birthday               <- map["birthday"]
            self.userable               <- map["userable"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
    
    class MetaData: Mappable {
        
        enum UserType: String {
            case client
            case trainer
        }
        
        //MARK: Variables
        
        var userType        : UserType?
        var token           : String?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.userType       <- (map["user_type"], EnumTransform<UserType>())
            self.token          <- map["token"]
        }
        
        init() {}
        required init?(map: Map) {
            
        }
    }
    
    //MARK: Properties
    
    var user: User {
        var user: User!
        if self.metaData?.userType == .client {
            user = Client()
        } else {
            user = Trainer()
        }
        
        user.id          = self.data?.userable?.id
        user.name        = self.data?.name
        user.email       = self.data?.email
        user.avatar      = self.data?.avatar
        user.birthday    = self.data?.birthday
        user.token       = self.metaData?.token
        
        return user
    }

    //MARK: Variables
    
    
    var data        : Data?
    var metaData    : MetaData?
    
    //MARK: Mappable
    
    func mapping(map: Map) {
     self.data                  <- map["data"]
        self.metaData           <- map["meta"]
    }
    
    init() {}
    required init?(map: Map) {
      
    }
}
