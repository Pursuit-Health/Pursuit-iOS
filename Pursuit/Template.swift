//
//  Template.swift
//  SwiftEngine
//
//  Created by Igor on 8/15/17.
//  Copyright © 2017 Igor. All rights reserved.
//

import ObjectMapper

class Template: Mappable {
    
    //MARK: Variables
    var templateId       : Int?
    var name            : String?
    var time            : Int?
    var imageId         : Int?
    
    //TODO: WTF?
    var simpleTemplatedata : SimpleTemplate?

    //MARK: Mappable
    
    func mapping(map: Map) {
        self.name               <- map["name"]
        self.time               <- map["time"]
        self.imageId            <- map["image_id"]
        self.templateId         <- map["id"]
        self.simpleTemplatedata <- map["data"]

    }
    
    required init?(map: Map) {
        
    }
    
    class SimpleTemplate: Mappable {
        //MARK: Variables
        
        var templateId      : Int?
        var name            : String?
        var time            : Int?
        var imageId         : Int?
        var exercises       : SimpleTemplate?
        var exercisesData   : [Exercises]?
    
        //MARK: Mappable
    
        func mapping(map: Map) {

            self.name               <- map["name"]
            self.time               <- map["time"]
            self.imageId            <- map["image_id"]
            self.templateId         <- map["id"]
            self.exercises          <- map["exercises"]
            self.exercisesData      <- map["data"]
    
        }
    
        required init?(map: Map) {
            
        }
    }
    
    class Exercises: Mappable {
        
        //MARK: Variables
        
        var name        : String?
        var type        : String?
        var exercisable : Exercises?
        var times       : Int?
        var count       : Int?
        var weight      : Int?
        var exercisesId : Int?
        var data        : Exercises?
        var dataArray   : [Exercises]?
        var execiseId    : Int?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.name               <- map["name"]
            self.type               <- map["type"]
            self.exercisable        <- map["exercisable"]
            self.times              <- map["times"]
            self.count              <- map["count"]
            self.weight             <- map["weight"]
            self.exercisesId        <- map["id"]
            self.dataArray          <- map["data"]
            self.data               <- map["data"]
            self.exercisesId        <- map["id"]
        }
        
        required init?(map: Map) {
            
        }
    }
    
    class CreateTemplateData: Mappable {
        
        var name            : String?
        var time            : Int?
        var imageId         : Int?
        var exercises       : [Exercises]?
        
        //MARK: Mappable
        
        func mapping(map: Map) {
            self.name               <- map["name"]
            self.time               <- map["time"]
            self.imageId            <- map["image_id"]
            self.exercises          <- map["exercises"]
   
        }
        
        required init?(map: Map) {
            
        }
    }
}

