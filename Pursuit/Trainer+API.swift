//
//  Trainer+API.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension Trainer {
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTrainersCompletion     = (_ user: [Trainer]?, _ error: ErrorProtocol?) -> Void
    
    
    class func registerTrainer(personalData: Trainer, completion: @escaping RegisterTrainerCompletion) {
        let api = PSAPI()
        
        api.registerTrainer(personalData: personalData.toJSON(), completion: completion)
    }
    
    class func getTrainers(completion: @escaping GetTrainersCompletion) {
        let api = PSAPI()
        
        api.getTrainers(completion: completion)
    }
    
}
