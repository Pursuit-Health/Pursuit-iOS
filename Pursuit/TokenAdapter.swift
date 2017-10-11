//
//  TokenAdapter.swift
//  Pursuit
//
//  Created by ігор on 10/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//
import Foundation
import HTTPStatusCodes
import Alamofire

class TokenAdapter: RequestAdapter {
    private let token: String
    
    init(accessToken: String) {
        self.token = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let newToken = User.shared.token {
            urlRequest.setValue("Bearer " + newToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
