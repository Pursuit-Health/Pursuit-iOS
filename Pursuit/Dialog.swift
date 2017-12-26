//
//  Dialog.swift
//  Pursuit
//
//  Created by ігор on 12/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Dialog: Mappable {
    
    //MARK: Private.Properties
    
    var userName: String?
    var userUID: String?
    var dialogId: String?
    var messages: [Message]?
    var userPhoto: String?
    var lastChange: TimeInterval?
    var unseenMessages: Bool?
    
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        self.userName       <- map["user.name"]
        self.userPhoto      <- map["user.photo"]
        self.userUID        <- map["user.uid"]
        self.messages       <- map["messages"]
        self.lastChange     <- map["last_change"]
        self.unseenMessages <- map["unseen"]
    }
    
    init(){}
    required init?(map: Map) {
        
    }
}
