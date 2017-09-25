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
    
    typealias GetClientEvents          = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    //MARK: Public 
    
    class func getAllClients(completion: @escaping GetAllClientsComletion) {
        let api = PSAPI()
        
        api.getAllClients(completion: completion)
    }
    
    class func getClientEvents(startdDate: String, endDate: String, completion: @escaping  GetClientEvents) {
        let api = PSAPI()
        
        api.getClientEvents(startDate: startdDate, endDate: endDate, completion: completion)
    }
}
