//
//  File.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//


//TODO: Use enum, make User.shared.auth.token

struct AppAuth {
    static let Token: String?   = User.shared.token
    static let IsClient: Bool?  = UserDefaults.standard.value(forKey: "isClient") as? Bool
}
