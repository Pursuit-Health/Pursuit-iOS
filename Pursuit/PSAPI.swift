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
    
    private func perform(_ request: Request) -> DataRequest? {
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
}

extension PSAPI {
}
