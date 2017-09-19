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

class PSAPI: APIHandable {
    
    //MARK: APIHandable
    
    var service: ServiceProtocol = AlamofireService()
    
    func error<T>(response: DataResponse<T>) -> ErrorProtocol? {
        guard let data = response.data else {
            return PSError.somethingWentWrong
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let message = json?["errorMessage"] as? String {
                return PSError.texted(text: message)
            }
        }
        
        return PSError.somethingWentWrong
    }
    
    //MARK: Public
    
    @discardableResult
    func registerTrainer(personalData: [String: Any], completion: RegisterTrainerCompletion? = nil) -> DataRequest? {
        let request = Request.registerTrainer(parameters: personalData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion?(response.result.value, error)
        })
    }
    
    @discardableResult
    func registerClient(personalData: [String: Any], completion: @escaping RegisterClientCompletion) -> DataRequest? {
        let request = Request.registerClient(parameters: personalData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func login(loginData: [String: Any], completion: @escaping LoginCompletion) -> DataRequest? {
        let request = Request.login(parameters: loginData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func forgotPassword(email: String, completion: @escaping ChangePasswordCompletion) -> DataRequest? {
        let request = Request.forgotPassword(parameters: ["email": email])
        return self.simple(request: request, completion: completion)
    }
    
    @discardableResult
    func setPassword(password: String, hash: String, completion: @escaping SetPasswordCompletion) -> DataRequest? {
        
        let request = Request.setPassword(parameters: ["hash": hash,
                                                       "password": password])
        return self.perform(request)?.responseJSON(completionHandler: { response in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(error)
        })
    }
    
    @discardableResult
    func changePassword(password: String, completion: @escaping ChangePasswordCompletion) -> DataRequest? {
        let request = Request.changePassword(parameters: ["password": password])
        return self.perform(request)?.responseJSON(completionHandler: { response in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(error)
        })
    }
    
    @discardableResult
    func getTrainers(completion: @escaping GetTrainersCompletion) -> DataRequest? {
        let request = Request.getTrainers()
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<User>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
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
                        completion(nil)
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    completion(encodingError.psError)
                }
        })
    }
    
    //MARK: Template
    
    @discardableResult
    func createTemplate(templateData: [String: Any], completion: @escaping CreateTemplateCompletion) -> DataRequest? {
        let request = Request.createTemplate(parameters: templateData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func editTemplate(templateId: String, templateData: [String: Any], completion: @escaping EditTemplateCompletion) -> DataRequest? {
        let request = Request.editTemplate(templateId: templateId, parameters: templateData)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func getAllTemplates(completion: @escaping GetAllTemplatesCompletion) -> DataRequest? {
        let request = Request.getAllTemplates()
        return self.perform(request)?.responseArray(completionHandler: { (response: DataResponse<[Template]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func getTemplateWithExercises(templateId: String, completion: @escaping GetTemplateWithExercises) -> DataRequest? {
        let request = Request.getTemplateWithExercise(templateId: templateId)
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Template>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func deleteTemplate(templateId: String, personalData: [String: Any], completion: @escaping DeleteTemplateCompletion) -> DataRequest?{
        let request = Request.deleteTemplate(templateId: templateId, parameters: personalData)
        return self.simple(request: request, completion: completion)
    }
    
    @discardableResult
    func getAllClients(completion: @escaping GetAllClientsComletion) -> DataRequest? {
        let request = Request.getAllClients()
        
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Client>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func getEventsInRange(startDate: String, endDate: String, completion: @escaping GetEventsInRange) -> DataRequest? {
        let request = Request.getAllEventsInRange(startDate: startDate, endDate: endDate)
        
        return self.perform(request)?.responseObject(completionHandler: { (response: DataResponse<Event>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        })
    }
    
    @discardableResult
    func createEvent(eventData: [String: Any], completion: @escaping CreateEventCompletion) -> DataRequest? {
        let request = Request.createEvent(parameters: eventData)
        return self.simple(request: request, completion: completion)
    }
}

extension PSAPI {
    
    //MARK: Typelias
    
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias ForgotPassword            = (_ error: ErrorProtocol?) -> Void
    
    typealias SetPasswordCompletion     = (_ error: ErrorProtocol?) -> Void
    
    typealias ChangePasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias ChangeAvatarCompletion    = (_ error: ErrorProtocol?) -> Void
    
    typealias GetTrainersCompletion     = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateTemplateCompletion  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias EditTemplateCompletion    = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias GetAllTemplatesCompletion = (_ template: [Template]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTemplateWithExercises  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias DeleteTemplateCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias GetAllClientsComletion    = (_ client: Client?, _ error: ErrorProtocol?) -> Void
    
    typealias GetEventsInRange          = (_ event: Event?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateEventCompletion     = (_ error: ErrorProtocol?) -> Void
}
