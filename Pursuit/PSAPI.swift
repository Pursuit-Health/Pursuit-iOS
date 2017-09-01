//
//  ElementsAPI.swift
//  q9elements.mobile
//
//  Created by volodymyrkhmil on 2/22/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SVProgressHUD
import Foundation

class PSAPI {
    
    class func avoidIndicator() {
        self.showIndicator = false
    }
    
    //MARK: Public.Properties
    
    var service: ServiceProtocol = AlamofireService()
    
    //MARK: Private.Properties
    
    //TODO: Change to groups
    private static var runningRequests  = 0
    private static var showIndicator    = true
    //MARK: Private.Methods
    
     func perform(_ request: Request) -> DataRequest? {
        let showIndicator   = PSAPI.showIndicator
        PSAPI.showIndicator = true
  
        if showIndicator {
            if PSAPI.runningRequests == 0 {
                SVProgressHUD.show()
            }
            PSAPI.runningRequests += 1
        }
        return self.service.request(request: request).response(completionHandler: { response in
            if showIndicator {
                PSAPI.runningRequests -= 1
                
                if PSAPI.runningRequests == 0 {
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
    
    private func isValid(statusCode: Int) -> Bool {
        return 200...299 ~= statusCode
    }
    
     private func isValid(response: HTTPURLResponse?, errorData: Data? = nil) -> PSError? {
        var error: PSError?
        guard let responseValue = response else {
            error = .internetConnection
            return error
        }
        if !self.isValid(statusCode: responseValue.statusCode) {
            guard let data      = errorData,
                let json        = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let statusCode  = json?["error"] as? Int,
                let message     = json?["errorMessage"] as? String else {
                    return PSError.texted(text: "Invalid status code").log()
            }
            error = PSError.error(description: message, statusCode: statusCode).log()
        }
        return error
    }

    @discardableResult
    func registerTrainer(personalData: [String: Any], completion: RegisterTrainerCompletion? = nil) -> DataRequest? {
        let request = Request.registerTrainer(parameters: personalData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
              var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
           completion?(response.result.value, error)
        })
    }
    
    @discardableResult
    func registerClient(personalData: [String: Any], completion: @escaping RegisterClientCompletion) -> DataRequest? {
        let request = Request.registerClient(parameters: personalData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func login(loginData: [String: Any], completion: @escaping LoginCompletion) -> DataRequest? {
        let request = Request.login(parameters: loginData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
}

extension PSAPI {
    
    //MARK: Typelias
    
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias LoginCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
}
