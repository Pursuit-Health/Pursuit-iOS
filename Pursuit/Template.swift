//
//  Template.swift
//  SwiftEngine
//
//  Created by Igor on 8/15/17.
//  Copyright © 2017 Igor. All rights reserved.
//

import ObjectMapper

class Template: NSObject, Mappable {
    
    //Create Template
    var email       : String?
    var template    : Template?
    var name        : String?
    var icon        : String?
    var duration    : String?
    var exercises   : [Template]?
    var sets        : String?
    var reps        : String?
    var weight      : String?
    
    func mapping(map: Map) {
        self.template   <- map["template"]
        self.name       <- map["name"]
        self.icon       <- map["icon"]
        self.duration   <- map["duration"]
        self.exercises  <- map["exercises"]
        self.sets       <- map["sets"]
        self.reps       <- map["reps"]
        self.weight     <- map["weight"]
    }
    
    required init?(map: Map) {
        
    }
}

extension Template {
    
}
