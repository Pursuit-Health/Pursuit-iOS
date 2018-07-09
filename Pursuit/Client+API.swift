//
//  Client+API.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

//IGOR: Check

extension Client {
    
    //MARK: Typealias 
    
    typealias GetAllClientsComletion    = (_ client: [Client]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetClientEvents           = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    typealias AssignTemplateCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias SubmitWorkOutCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias GetClientTemplates        = (_ workout: [Workout]?, _ error: ErrorProtocol?) -> Void
    
    typealias ChangeTrainerCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias CheckClientCompletion = (_ error: ErrorProtocol?) -> Void
    
    //MARK: Public 
    
    class func getAllClients(completion: @escaping GetAllClientsComletion) {
        let api = PSAPI()
        api.showProgress = false
        api.getAllClients(completion: completion)
    }
    
    class func getClientEvents(startdDate: String, endDate: String, completion: @escaping  GetClientEvents) {
        let api = PSAPI()
        
        api.getClientEvents(startDate: startdDate, endDate: endDate, completion: completion)
    }
    
    class func assignTemplate(clientId: String, templateId: String, completion: @escaping AssignTemplateCompletion) {
        let api = PSAPI()
        
        api.assignTemaplate(clientId: clientId, templateId: templateId, completion: completion)
    }
    
    class func submitWorkout(workoutId: String, completion: @escaping SubmitWorkOutCompletion) {
        let api = PSAPI()
        
        api.submitWorkout(workoutId: workoutId, completion: completion)
    }
    
    class func changeTrainer(trainerCode: String, completion: @escaping ChangeTrainerCompletion) {
        let api = PSAPI()
        
        api.changeTrainer(trainerCode: trainerCode, completion: completion)
    }
    
    class func check(completion: @escaping CheckClientCompletion) {
        let api = PSAPI()
        api.check(completion: completion)
    }
    
    //TODO: Maybe save it to clients property
    func getTemplatesAsTrainer(completion: @escaping GetClientTemplates) {
        if let id = self.id {
            let api = PSAPI()
            api.showProgress = false
            api.getClientTemplates(clientId: id, completion: completion)
        } else {
            completion(nil, PSError.somethingWentWrong)
        }
    }
}
