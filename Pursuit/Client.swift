//
//  Client.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Client: User, Equatable, Hashable {
    
    //MARK: Hashable
    
    var hashValue: Int = 0
    
    //MARK: Equatable
    
    static func ==(lhs: Client, rhs: Client) -> Bool {
        return lhs.id == rhs.id
    }
    
    //MARK: Typealias
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    //MARK: Private.Properties
    
    var isSelected: Bool = false
    
    //MARK: Mappable
    
    var trainer: Trainer?
    
    var clientName          : String?
    var clientAvatar        : String?
    var clietnUID          : String?
    
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
        self.clietnUID          <- map["user.data.uid"]
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
