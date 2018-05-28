//
//  Set.swift
//  Pursuit
//
//  Created by ігор on 5/22/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import ObjectMapper

class SetsData: Mappable {
    
    var id: Int?
    
    var reps_min: Int?
    var reps_max: Int?
    var weight_min: Int?
    var weight_max: Int?
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.reps_min       <- map["reps_min"]
        self.reps_max       <- map["reps_max"]
        self.weight_min     <- map["weight_min"]
        self.weight_max     <- map["weight_max"]
    }
    
    init() {}
    
    required init?(map: Map) {
        
    }
}
