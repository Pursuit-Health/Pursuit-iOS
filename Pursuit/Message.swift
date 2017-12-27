//
//  Message.swift
//  Pursuit
//
//  Created by ігор on 12/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import ObjectMapper

class Message: Mappable, Hashable, Equatable{
    
    
    var hashValue: Int {
        return self.messageId.hashValue
    }
    
    //MARK: Private.Properties
    
    var text: String?
    var senderName: String?
    var senderId: String?
    var created: TimeInterval?
    var messageId: String = ""
    var photo: String?
    var isHideAvatar: Bool?
    var userPhoto: String?
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        
        self.text <- map["text"]
        self.created <- map["created_at"]
        self.senderId <- map["sender_id"]
        self.photo  <- map["photo"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.messageId == rhs.messageId
}
