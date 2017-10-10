//
//  TokenRetrier.swift
//  f2x
//
//  Created by Igor on 9/18/17.
//Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import HTTPStatusCodes
import Alamofire

class TokenRetrier: RequestRetrier {
    
    private enum Constants {
        static let retriesCount = 3
    }
    
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var retriesCount: Int = 0
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse,
            let statusCode = HTTPStatusCode(rawValue: response.statusCode),
            statusCode == .unauthorized {
            requestsToRetry.append(completion)
            
            if retriesCount >= Constants.retriesCount {
                requestsToRetry.forEach { $0(false, 0.0) }
                requestsToRetry.removeAll()
                retriesCount = 0
                
                return
            }
            
            User.refreshToken(completion: {[weak self] (error) in

                guard let strongSelf = self else { return }
                
                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                
                strongSelf.requestsToRetry.forEach { $0((error != nil), 0.0) }
                
                //strongSelf.requestsToRetry.removeAll()
                
                strongSelf.retriesCount += 1
                
            })
        } else {
            completion(false, 0.0)
        }
    }
}
