//
//  Template.swift
//  SwiftEngine
//
//  Created by Igor on 8/15/17.
//  Copyright © 2017 Igor. All rights reserved.
//

import ObjectMapper

class Template: Mappable {
    
    //MARK: Nested
    
    class Exercises: Mappable {
        
        //MARK: Variables
        var exerciseId  : Int?
        var name        : String?
        var type        : String?
        
        
        var times       : Int?
        var count       : Int?
        var weight      : Int?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            
            self.exerciseId         <- map["id"]
            self.name               <- map["name"]
            self.type               <- map["type"]
           
            self.times              <- map["data.times"]
            self.count              <- map["data.count"]
            self.weight             <- map["data.weight"]
      
        }
        
        init() {}
        
        required init?(map: Map) {
            
        }
    }
    
    //MARK: Variables
    var templateId       : Int?
    var name            : String?
    var time            : Int?
    var imageId         : Int?
    var exercises       : [Exercises]?
    var exercisesForUpload : [Exercises]?

    //MARK: Mappable
    
    func mapping(map: Map) {
        self.name               <- map["name"]
        self.time               <- map["time"]
        self.imageId            <- map["image_id"]
        self.templateId         <- map["id"]
        self.exercises          <- map["exercises.data"]
        self.exercisesForUpload <- map["exercises"]
    }
    
   init() {}
    required init?(map: Map) {
        
    }
}

