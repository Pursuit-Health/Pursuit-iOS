//
//  Event.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Event: Mappable {
    
    //MARK: Private.Properties
    
    var location            : String?
    var startAt             : String?
    var endAt               : String?
    var date                : String?
    var clients             : [Client]?
    var clientsForUpload    : [Int]?
    
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        
        self.location       <- map["location"]
        self.startAt        <- map["start_at"]
        self.endAt          <- map["end_at"]
        self.date           <- map["date"]
        self.clients        <- map["clients.data"]
        self.clientsForUpload <- map["clients"]
    }
    
     init(){}
    required init?(map: Map) {
        
    }
}

