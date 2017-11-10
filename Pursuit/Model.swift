//
//  Model.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class Model {
    var name: String = ""
    var date: String = ""
    var selected: Bool = false
    
    init(name: String, date: String, selected: Bool) {
        self.name = name
        self.date = date
        self.selected = selected
    }

}
