//
//  Trainer.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper
import SwiftDate

class Trainer: User {
    
    override var coordinator: Coordinator? {
        return self.trainerCoordinator
    }
    
    //MARK: Private.Properties
    
    var trainerCoordinator = TrainerCoordinator()
    
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
    
    override var type: UserType? {
        return .trainer
    }
    
    override func isValidCode() -> Bool? {
        return self.code == "v7vnc6"
    }
    
    override func signUp(completion: @escaping RegisterTrainerCompletion) {
        let api = PSAPI()
        
        api.registerTrainer(personalData: self.createSignUpParameters(), completion: { (user, error) in
            if error == nil {
                let dateFormatter = DateFormatters.serverTimeFormatter
                var date = DateInRegion(absoluteDate: Date())
                date = date + 2.weeks
                let converted = dateFormatter.string(from: date.absoluteDate)
                Trainer.subscribeTo(type: "pro-5", valid_until: converted, completion: { (error) in
                    
                })
            }
            completion(user, error)
        })
    }
}
