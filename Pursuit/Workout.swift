//
//  Workout.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Workout: Mappable {
    
    var id                      : Int?
    var template                : Template?
    var currentWorkDay          : String?
    
    func mapping(map: Map) {
        self.id                <- map["id"]
        self.template          <- map["template.data"]
        self.currentWorkDay     <- map["currentWorkoutDay.data.date"]
    }
    
    required init?(map: Map) {
        
    }
}
