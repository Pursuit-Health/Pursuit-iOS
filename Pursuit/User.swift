//
//  User.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

enum UserType: String {
    case client = "client"
    case trainer = "trainer"
}

class User: Mappable {
    
    //MARK: Private.Properties
    
    static public var shared = User()
    
    var token: String? {
        get {
            let keychain = PursuitKeychain()
            return keychain.token
        }
        set(newValue) {
            let keychain        = PursuitKeychain()
            keychain.token      = newValue
        }
    }
    
    var firToken: String? {
        get {
            let keychain = PursuitKeychain()
            return keychain.firToken
        }
        set(newValue) {
            let keychain        = PursuitKeychain()
            keychain.firToken      = newValue
        }
    }
    
    var coordinator: Coordinator? {
        return nil;
    }
    
    var code: String?
    
    //MARK: Mappable
    
    var id                  : Int?
    var name                : String?
    var email               : String?
    var password            : String?
    var birthday            : String?
    var avatar              : String?
    var signInName : String?
    
    var invitation_code : String?
    var pending_client_count : Int?
    
    func mapping(map: Map) {
        self.name            <- map["user.data.name"]
        self.email           <- map["user.data.email"]
        self.password        <- map["user.data.password"]
        self.birthday        <- map["user.data.birthday"]
        self.id              <- map["user.data.userable.data.id"]
        self.avatar          <- map["user.data.avatar"]
    }
//    
//    "invitation_code": "ZZX",
//    "pending_client_count": 0,
//    "user_type": "trainer"
    
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
    
    var type: UserType? {
        return nil
    }

    
    func signUp(completion: @escaping RegisterCompletion) {
        
    }
    
    func isValidCode() -> Bool? {
        return nil
    }
    
    func updateDetailsWorkout(workout: Workout, completion: Workout.GetClientsWorkoutDetails? = nil) {
        
    }
}

