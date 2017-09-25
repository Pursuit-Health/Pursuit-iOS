//
//  Event+API.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension Event {
    
    //MARK: Typealias
    
    typealias GetEventsInRange          = (_ event: Event?, _ error: ErrorProtocol?) -> Void
    typealias CreateEventCompletion     = (_ error: ErrorProtocol?) -> Void
    
    //MARK: Public
    
    class func createTemplate(eventData: Event, completion: @escaping CreateEventCompletion) {
        let api = PSAPI()
        
        api.createEvent(eventData: eventData.toJSON(), completion: completion)
    }
}
