//
//  User+API.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension User {
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
//    class func signUp(signUpInfo: PersonalData, completion: @escaping SignUpCompletion) {
//        let api = PSAPI()
//        
//        api.signUp(signUpInfo: signUpInfo.toJSON(), completion: completion)
//    }
    
    class func registerTrainer(personalData: PersonalData, completion: @escaping RegisterTrainerCompletion) {
        let api = PSAPI()
        
        api.registerTrainer(personalData: personalData.toJSON(), completion: completion)
    }
    
    class func registerClient(personalData: PersonalData, completion: @escaping RegisterClientCompletion) {
        let api = PSAPI()
        
        api.registerClient(personalData: personalData.toJSON(), completion: completion)
    }
    
    class func login(loginData: PersonalData, completion: @escaping LoginCompletion) {
        let api = PSAPI()
        
        api.login(loginData: loginData.toJSON(), completion: completion)
    }
}
