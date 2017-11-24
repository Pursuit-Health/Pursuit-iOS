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

//"data": {
//    "id": 452,
//    "name": "Test Template",
//    "notes": null,
//    "start_at": 1511481600,
//    "templateExercises": {
//        "data": [
//        {
//        "id": 2253,
//        "type": 1,
//        "name": "numquam temporibus sed",
//        "sets": 1,
//        "reps": 2,
//        "rest": 4,
//        "notes": null,
//        "weight": 3,
//        "exercise": {
//        "data": {
//        "id": 1,
//        "name": "numquam temporibus sed",
//        "image_url": "https://lorempixel.com/640/480/?55614",
//        "description": "Nisi omnis et dolores pariatur expedita id. Ipsam sapiente aut sed dignissimos enim."
//        }
//        },
//        "done": {
//        "data": {
//        "value": false
//        }
//        }
//}

