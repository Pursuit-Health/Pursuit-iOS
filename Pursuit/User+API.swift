//
//  User+API.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension User {
    
    //MARK: Typealias
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias ForgotPasswordCompletion  = (_ success: Bool) -> Void
    typealias ChangePasswordCompletion  = (_ success: Bool) -> Void
    typealias ChangeAvatarCompletion    = (_ success: Bool) -> Void

    //MARK: Public
    
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
        
        api.login(loginData: loginData.toJSON()) { (user, error) in
            
            if let user = user {
                if let token = user.metaData?.token {
                  self.token = token
                }
            }
            completion(user, error)
        }
    }
    
    class func forgotPassword(email: String, completion: @escaping ForgotPasswordCompletion) {
        let api = PSAPI()
        
        api.forgotPassword(email: email, completion: completion)
    }
    
    class func changePassword(password: String, completion: @escaping ChangePasswordCompletion) {
        let api = PSAPI()
        
        api.changePassword(password: password, completion: completion)
    }
    
    class func uploadAvatar(data: Data, completion: @escaping  ChangeAvatarCompletion) {
        let api = PSAPI()
        
        api.uploadAvatar(data: data, completion: completion)
    }
}
