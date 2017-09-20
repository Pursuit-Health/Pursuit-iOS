//
//  User+API.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

//IGOR: Check
extension User {
    
    //MARK: Typealias
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias ForgotPasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    typealias SetPasswordCompletion     = (_ error: ErrorProtocol?) -> Void
    typealias ChangePasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    typealias ChangeAvatarCompletion    = (_ error: ErrorProtocol?) -> Void
    

    //MARK: Public
    
    class func registerClient(personalData: Trainer, completion: @escaping RegisterClientCompletion) {
        let api = PSAPI()
        
        api.registerClient(personalData: personalData.toJSON(), completion: completion)
    }
    
    class func login(loginData: User, completion: @escaping LoginCompletion) {
        let api = PSAPI()
        
        api.login(loginData: loginData.toJSON()) { (user, error) in
            
            if let user = user {
                if let token = user.token {
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
    
    class func setPassword(password: String, hash: String, completion: @escaping SetPasswordCompletion) {
        let api = PSAPI()
        
        api.setPassword(password: password, hash: hash, completion: completion)
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
