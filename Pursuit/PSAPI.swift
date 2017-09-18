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
    //IGOR: Check
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
    
    @discardableResult
    func forgotPassword(email: String, completion: @escaping ChangePasswordCompletion) -> DataRequest? {
        let request = Request.forgotPassword(parameters: ["email": email])
        return self.perform(request)?.responseJSON(completionHandler: { response in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            if let statusCode = response.response?.statusCode {
                completion(statusCode == 200)
            }
        })
    }
    
    @discardableResult
    func setPassword(password: String, hash: String, completion: @escaping SetPasswordCompletion) -> DataRequest? {
        
        let request = Request.setPassword(parameters: ["hash": hash,
                                                       "password": password])
        return self.perform(request)?.responseJSON(completionHandler: { response in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            if let statusCode = response.response?.statusCode {
                completion(statusCode == 200)
            }
        })
    }
    
    @discardableResult
    func changePassword(password: String, completion: @escaping ChangePasswordCompletion) -> DataRequest? {
        let request = Request.changePassword(parameters: ["password": password])
        return self.perform(request)?.responseJSON(completionHandler: { response in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            if let statusCode = response.response?.statusCode {
                completion(statusCode == 200)
            }
        })
    }
    
    func getTrainers(completion: @escaping GetTrainersCompletion) -> DataRequest? {
        let request = Request.getTrainers()
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            completion(response.result.value, error)
        })
    }
    
    func uploadAvatar(data: Data, completion: @escaping ChangeAvatarCompletion) {
        guard let token = User.token else {return}
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "avatar")
                
        },
            to: "http://dev.nerdzlab.com/v1/settings/avatar", method : .post, headers: ["Authorization":"Bearer" + token],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        completion(true)
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    //MARK: Template
    
    func createTemplate(templateData: [String: Any], completion: @escaping CreateTemplateCompletion) -> DataRequest? {
        let request = Request.createTemplate(parameters: templateData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    func editTemplate(templateId: String, templateData: [String: Any], completion: @escaping EditTemplateCompletion) -> DataRequest? {
        let request = Request.editTemplate(templateId: templateId, parameters: templateData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    func getAllTemplates(completion: @escaping GetAllTemplatesCompletion) -> DataRequest? {
        let request = Request.getAllTemplates()
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    func getTemplateWithExercises(templateId: String, completion: @escaping GetTemplateWithExercises) -> DataRequest? {
        let request = Request.getTemplateWithExercise(templateId: templateId)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    func deleteTemplate(templateId: String, personalData: [String: Any], completion: @escaping DeleteTemplateCompletion) -> DataRequest?{
        let request = Request.deleteTemplate(templateId: templateId, parameters: personalData)
        return self.perform(request)?.responseJSON(completionHandler: { response in
           
            if self.isValid(response: response.response) != nil {

            }
            
            if let statusCode = response.response?.statusCode {
                completion(statusCode == 200)
            }
        })
    }
    
    func getAllClients(completion: @escaping GetAllClientsComletion) -> DataRequest? {
        let request = Request.getAllClients()
        
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Client>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            completion(response.result.value, error)
        })
    }
    
    func getEventsInRange(startDate: String, endDate: String, completion: @escaping GetEventsInRange) -> DataRequest? {
        let request = Request.getAllEventsInRange(startDate: startDate, endDate: endDate)
        
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Event>) in
            var error: PSError?
            if let responseError = self.isValid(response: response.response) {
                error = responseError
            }
            completion(response.result.value, error)
        })
    }
    
    func createEvent(eventData: [String: Any], completion: @escaping CreateEventCompletion) -> DataRequest? {
        let request = Request.createEvent(parameters: eventData)
        
        return self.perform(request)?.responseJSON(completionHandler: { response in
            
            if self.isValid(response: response.response) != nil {
                
            }
            
            if let statusCode = response.response?.statusCode {
                completion(statusCode == 200)
            }
        })
    }
}

extension PSAPI {
    
    //MARK: Typelias
    
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias ForgotPassword            = (_ success: Bool) -> Void
    
    typealias SetPasswordCompletion     = (_ success: Bool) -> Void
    
    typealias ChangePasswordCompletion  = (_ success: Bool) -> Void
    
    typealias ChangeAvatarCompletion    = (_ success: Bool) -> Void
    
    typealias GetTrainersCompletion     = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateTemplateCompletion  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias EditTemplateCompletion    = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias GetAllTemplatesCompletion = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTemplateWithExercises  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias DeleteTemplateCompletion  = (_ success: Bool) -> Void
    
    typealias GetAllClientsComletion    = (_ client: Client?, _ error: ErrorProtocol?) -> Void
    
    typealias GetEventsInRange          = (_ event: Event?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateEventCompletion     = (_ success: Bool) -> Void
}
