//
//  Coordinator.swift
//  Pursuit
//
//  Created by ігор on 11/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation

protocol Coordinator {
    func start(from controller: UIViewController?)
    func start(from: ClientsVC, with client: Client)
    func start(from controller: ClientInfoVC, workout: Workout)
    static func start(from controller: UIViewController?)
}

extension Coordinator {
    func start(from controller: UIViewController?){}
    func start(from: ClientsVC, with client: Client){}
    func start(from controller: ClientInfoVC, workout: Workout){}
    static func start(from controller: UIViewController?){}
}

