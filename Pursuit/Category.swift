//
//  Category.swift
//  Pursuit
//
//  Created by ігор on 11/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Category: Mappable {
    
    var categoryId: Int?
    var name: String?
    var image_id: Int?
    
    func mapping(map: Map) {
        self.categoryId         <- map["id"]
        self.name               <- map["name"]
        self.image_id           <- map["image_id"]
    }
    
    init() {
    }
    
    required init?(map: Map) {
        
    }
}
