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
    
    var location: String?
    var startAt: String?
    var endAt: String?
    var date: String?
    var clients: [Int]?
    
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        
    }
    
    required init?(map: Map) {
        
    }
}

//{
//    "location": "somewhere",
//    "start_at": "10:10",
//    "end_at": "12:10",
//    "date": "2017-11-11",
//    "clients": [
//    104,
//    53
//    
//    ]
//}
