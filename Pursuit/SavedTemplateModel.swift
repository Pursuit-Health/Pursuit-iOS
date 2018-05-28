//
//  SavedTemplate.swift
//  Pursuit
//
//  Created by ігор on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class SavedTemplateModel: Mappable {
    
    var id          : Int?
    var name        : String?
    var notes       : String?
    var exercises   : [ExcersiseData]?
    
    
     func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.notes      <- map["notes"]
        self.exercises  <- map["exercises"]
    }

    init() {}
    
    required init?(map: Map) {
        
    }
}
