//
//  ExcersiseData.swift
//  Pursuit
//
//  Created by admin on 11/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

//"id": 2253,
//"type": 1,
//"name": "quibusdam aut eaque",
//"sets": 1,
//"reps": 2,
//"rest": 4,
//"notes": null,
//"weight": 3,
//"exercise": {
//    "data": {
//        "id": 1,
//        "name": "quibusdam aut eaque",
//        "image_url": "https://lorempixel.com/640/480/?...",
//        "description": "Qui aut assumenda id. Ab id totam ut hic et alias deleniti. Similique mollitia quo et ex alias dolorum. Nihil nisi quam dolore autem animi."
//    }
//},
//"done": {
//    "data": {
//        "value": false
//    }
//}
//}

class ExcersiseData: Mappable {
    
    
    class InnerExcersise: Mappable {
        
        var name: String?
        var description: String?
        var imageURL: URL?
        var id: Int?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            self.name           <- map["name"]
            self.description    <- map["description"]
            self.imageURL       <- map["image_url"]
            self.id             <- map["id"]
        }
        

    }
    //MARK: Nested
    
    enum ExcersiseType: Int {
        case warmup = 1
        case workout = 2
        case cooldown = 3
        
        var name: String {
            switch self {
            case .warmup:
                return "Warmup"
            case .workout:
                return "Workout"
            case .cooldown:
                return "Cooldown"
            }
        }
    }
    
    var id          : Int?
    var type        : ExcersiseType?
    var name        : String?
    var sets        : Int?
    var reps        : Int?
    
    var weight      : Int?
    var rest        : Int?
    var notes       : String?
    var exDesc      : String?
    
    var exercise_id : Int?
    
    var isDone      : Bool?
    var selected    : Bool?
    var innerExercise: InnerExcersise?
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.type           <- (map["type"], EnumTransform<ExcersiseType>())
        self.name           <- map["name"]
        self.sets           <- map["sets"]
        self.reps           <- map["reps"]
        self.weight         <- map["weight"]
        self.notes          <- map["notes"]
        self.innerExercise  <- map["exercise"]
        self.isDone         <- map["done.data.value"]
        self.exercise_id    <- map["exercise_id"]
        self.rest           <- map["rest"]
/*
         { inner, error in
         self.excersise = inner.map { obj in
         let ex = Excersise()
         ex.ex = obj
         return ex
         }
         }
 */
    }
    
    init() {
    }
    
    required init?(map: Map) {
        
    }
}
