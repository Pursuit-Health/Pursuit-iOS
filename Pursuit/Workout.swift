//
//  Workout.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Workout: Mappable {
    
    var excersises: [ExcersiseData]?
    
    var id                      : Int?
    var template                : Template?
    var currentWorkDay          : String?
    
    var name: String?
    var startAt: Double?
    var templateExercises: [Template.Exercises]?
    var isDone: Bool?
    
    func mapping(map: Map) {
        self.id                <- map["id"]
        self.template          <- map["template.data"]
        self.currentWorkDay     <- map["currentWorkoutDay.data.date"]
        
        self.name           <- map["name"]
        self.isDone         <- map["done.data.value"]
        self.startAt        <- map["start_at"]
    }
    
    required init?(map: Map) {
        
    }
}

