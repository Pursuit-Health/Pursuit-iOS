//
//  Client.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Client: User {
    
    //MARK: Typealias
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    //MARK: Private.Properties
    
    var trainer: Trainer?
    
    var clientName          : String?
    var clientAvatar        : String?
    
    //MARK: Mappable
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        if map.mappingType == .fromJSON && self.id == nil {
            self.id <- map["id"]
        } else if map.mappingType == .toJSON {
            self.id <- map["id"]
        }
        
        self.clientName         <- map["user.data.name"]
        self.clientAvatar       <- map["user.data.avatar"]
    }
    
    override func createSignUpParameters() -> [String : String] {
        var parameters = super.createSignUpParameters()
        parameters["trainer_id"] = "\(self.id ?? 0)"
        return parameters
    }
    
    override func signUp(completion: @escaping RegisterClientCompletion) {
        let api = PSAPI()
        api.registerClient(personalData: self.createSignUpParameters(), completion: completion)
    }
}
