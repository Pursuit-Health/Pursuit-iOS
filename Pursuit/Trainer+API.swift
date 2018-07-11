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
    
    typealias GetInvitationCode         = (_ code: String?, _ error: ErrorProtocol?) -> Void
    
    typealias GetPendingClientsCompletion = (_ client: [Client]?, _ error: ErrorProtocol?) -> Void
    
    typealias AcceptClientCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias RejectClientCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias DeleteClientCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias SubscribeToCompletion = (_ error: ErrorProtocol?) -> Void
    
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
    
    class func getInvitationCode(completion: @escaping GetInvitationCode) {
        let api = PSAPI()
        api.getInvitationCode(completion: completion)
    }
    
    class func acceptClient(clientId: String, completion: @escaping AcceptClientCompletion) {
        let api = PSAPI()
        api.acceptClient(clientId: clientId, completion: completion)
    }
    
    class func rejectClient(clientId: String, completion: @escaping RejectClientCompletion) {
        let api = PSAPI()
        api.rejectClient(clientId: clientId, completion: completion)
    }
    
    class func getPendingClients(completion: @escaping GetPendingClientsCompletion) {
        let api = PSAPI()
        api.showProgress = false
        api.getPendingClients(completion: completion)
    }
    
    class func deleteClient(clientId: String, completion: @escaping DeleteClientCompletion) {
        let api = PSAPI()
        
        api.deleteClient(clientId: clientId, completion: completion)
    }
    
    class func subscribeTo(type: String, valid_until: String, completion: @escaping  SubscribeToCompletion) {
        let api = PSAPI()
        api.subscribeTo(type: type, valid_until: valid_until, completion: completion)
    }
}
