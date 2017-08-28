//
//  User+API.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension User {
    
    typealias SignUpCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    class func signUp(signUpInfo: PersonalData, completion: @escaping SignUpCompletion) {
        let api = PSAPI()
        
        api.signUp(signUpInfo: signUpInfo.toJSON(), completion: completion)
    }
}
