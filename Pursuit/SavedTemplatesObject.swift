//
//  SavedTemplate.swift
//  Pursuit
//
//  Created by Igor on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//
import ObjectMapper

import Foundation

class SavedTemplatesObject: Mappable {
    
    //MARK: Variables
    var savedTemplates        : [SavedTemplateModel]?
    var current_page    : Int?
    var total_pages     : Int?
    
    //MARK: Mappable
    
    func mapping(map: Map) {
        self.savedTemplates       <- map["data"]
        self.current_page   <- map["meta.pagination.current_page"]
        self.total_pages    <- map["meta.pagination.total_pages"]
    }
    
    required init?(map: Map) {
        
    }
}
