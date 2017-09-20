//
//  Client.swift
//  Pursuit
//
//  Created by ігор on 9/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Client: User {

    //MARK: Private.Properties
    
    var trainer: Trainer?
    
    //MARK: Mappable
    
     override func mapping(map: Map) {
        super.mapping(map: map)
       self.trainer <- map["userable"]
    }
    
   override init() {
    super.init()
    }
    
    required init?(map: Map) {
       super.init(map: map)
    }
    

}
