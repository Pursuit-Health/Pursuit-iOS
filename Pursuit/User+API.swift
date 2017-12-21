//
//  User+API.swift
//  Pursuit
//
//  Created by ігор on 8/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

//IGOR: Check
import Firebase
extension User {
    
    //MARK: Typealias
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias GetUserInfoCompletion     = (_ user: User?, _ error: ErrorProtocol?) -> Void
    typealias ForgotPasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    typealias SetPasswordCompletion     = (_ error: ErrorProtocol?) -> Void
    typealias ChangePasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    typealias ChangeAvatarCompletion    = (_ error: ErrorProtocol?) -> Void
    typealias RefreshTokenCompletion    = (_ error: ErrorProtocol?) -> Void
     typealias GetFireBaseTokenCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    

    //MARK: Public

    
    class func login(username: String, password: String, user: User, completion: @escaping LoginCompletion) {
        let api = PSAPI()
        
        api.login(email: username, password: password) { (user, error) in
            
            if let user = user {
                if let token = user.token {
                  self.shared.token = token
                    User.getFireBaseToken(completion: { (user, error) in
                        
                    })
                }
            }
            completion(user, error)
        }
    }
    
    class func refreshToken(completion: @escaping RefreshTokenCompletion) {
        let api = PSAPI()
        api.refreshToken(completion: completion)
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
    
    class func getUserInfo(completion: @escaping GetUserInfoCompletion) {
        let api = PSAPI()
        
        api.getUserInfo(completion: completion)
    }

    class func getFireBaseToken(completion: @escaping GetFireBaseTokenCompletion) {
        let api = PSAPI()
        api.getFireBaseToken { (user, error) in

        }
    }
 }
