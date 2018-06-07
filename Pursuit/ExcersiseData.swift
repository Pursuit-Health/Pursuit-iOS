//
//  ExcersiseData.swift
//  Pursuit
//
//  Created by admin on 11/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class ExcersiseData: Mappable, Equatable, Hashable {
    //MARK: Hashable
    
    var hashValue: Int = 0
    
    //MARK: Equatable
    
    static func ==(lhs: ExcersiseData, rhs: ExcersiseData) -> Bool {
        return lhs.id == rhs.id
    }
    
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
        
        init () {}

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
    
    var id              : Int?
    var type            : ExcersiseType?
    var name            : String?
    var sets_count      : Int?
    var reps            : Int?
    
    var weight          : Int?
    var rest            : String?
    var notes           : String?
    var exDesc          : String?
    
    var exercise_id     : Int?
    
    var isDone          : Bool?
    var selected        : Bool?
    var innerExercise   : InnerExcersise?
    var description     : String?
    var sets            : [SetsData]?
    var isStraitSets    : Bool?
    var isWeighted      : Bool?
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.type           <- (map["type"], EnumTransform<ExcersiseType>())
        self.name           <- map["name"]
        self.sets_count     <- map["sets_count"]
        self.reps           <- map["reps"]
        self.weight         <- map["weight"]
        self.notes          <- map["notes"]
        self.innerExercise  <- map["exercise.data"]
        self.isDone         <- map["done.data.value"]
        self.exercise_id    <- map["exercise_id"]
        self.rest           <- map["rest"]
        self.description    <- map["description"]
        self.sets           <- map["sets"]
        if self.sets == nil {
           self.sets           <- map["sets.data"]
        }
    
    }
    
    init() {
    }
    
    required init?(map: Map) {
        
    }
}
