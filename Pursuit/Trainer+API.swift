//
//  Trainer+API.swift
//  Pursuit
//
//  Created by ігор on 9/19/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension Trainer {
    
    //MARK: Typealias
    
    typealias GetTrainersCompletion     = (_ user: [Trainer]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetEventsInRange          = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetClientTemplates        = (_ workout: [Workout]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTrainerCategories      = (_ workout: [Category]?, _ error: ErrorProtocol?) -> Void
    
    //MARK: Public
    class func getTrainers(completion: @escaping GetTrainersCompletion) {
        let api = PSAPI()
        
        api.getTrainers(completion: completion)
    }
    
    class func getTrainerEvents(startdDate: String, endDate: String, completion: @escaping  GetEventsInRange) {
        let api = PSAPI()
        
        api.getTrainerEvents(startDate: startdDate, endDate: endDate, completion: completion)
    }
    
    class func getCategories(completion: @escaping GetTrainerCategories) {
        let api = PSAPI()
        api.getCategories { (categories, error) in
            completion(categories, error)
        }
    }
}
