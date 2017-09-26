//
//  Trainer.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Trainer: User {
    
    //MARK: Typealias
    
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    var trainerAvatar: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        if map.mappingType == .fromJSON && self.id == nil {
            self.id <- map["id"]
        } else if map.mappingType == .toJSON {
            self.id <- map["id"]
        }
        self.trainerAvatar       <- map["user.data.avatar"]
    }
    
    override func signUp(completion: @escaping RegisterTrainerCompletion) {
        let api = PSAPI()
        
        api.registerTrainer(personalData: self.createSignUpParameters(), completion: completion)
    }
}
