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
import Firebase

class PSAPI: APIHandable {
    
    //MARK: APIHandable
    
    var service: ServiceProtocol = AlamofireService()
    
    func error<T>(response: DataResponse<T>) -> ErrorProtocol? {
        guard let data = response.data, data.count > 0 else {
            if let error = response.error {
                let error = error as NSError
                if error.code == URLError.Code.notConnectedToInternet.rawValue {
                    return PSError.internetConnection
                }
                return PSError.custom(error: error, statusCode: error.code)
            }
            return PSError.somethingWentWrong
        }
        let statusCode = response.response?.statusCode
        if statusCode == 401 {
            return PSError.unAuthorized
        }else if statusCode == 500 {
            return PSError.serverUnavalble
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let message = json?["message"] as? String {
                return PSError.texted(text: message)
            }
        }
        
        return PSError.somethingWentWrong
    }
    
    //MARK: Public
    
    @discardableResult
    func refreshToken(completion: @escaping RefreshTokenCompletion) -> DataRequest? {
        let request = Request.refreshToken()
        return self.service.request(request: request).responseJSON { (response) in
            var error: ErrorProtocol?
            
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                if let headers  = response.response?.allHeaderFields {
                    if let token  = headers["Authorization"] as? String {
                        print(token)
                        let newToken = token.replacingOccurrences(of: "Bearer ", with: "")
                        
                        User.shared.token = newToken
                    }
                }
            }
            completion(error)
        }
    }
    
    @discardableResult
    func registerTrainer(personalData: [String : String], completion: @escaping RegisterTrainerCompletion) -> DataRequest? {
        
        let request = Request.registerTrainer(parameters: personalData)
        return self.perform(request)?.responseJSON { (response) in
            var error: ErrorProtocol?
            var user: Trainer?
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                switch response.result {
                case .success(let JSON):
                    let userData = ((JSON as? [String : Any])?["data"] as? [String : Any])
                    let metaData = ((JSON as? [String : Any])?["meta"] as? [String : String])
                    if let type = metaData?["user_type"], let token = metaData?["token"], let userData = userData {
                        let objectData = ["user" : userData]
                        if type == "trainer" {
                            UserDefaults.standard.set(false, forKey:"isClient")
                            user = Trainer(JSON: objectData)
                        }
                        User.shared.token = token
                        
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            User.getFireBaseToken(completion: completion)
                       // }
                    }
                    
                case .failure(let serverError):
                    error = serverError.psError
                }
            }
            completion(user, error)
        }
    }
    
    //TODO: Refactore this code
    @discardableResult
    func registerClient(personalData: [String : String], completion: @escaping RegisterClientCompletion) -> DataRequest? {
        let request = Request.registerClient(parameters: personalData)
        return self.perform(request)?.responseJSON { (response) in
            var error: ErrorProtocol?
            var user: Client?
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                switch response.result {
                case .success(let JSON):
                    let userData = ((JSON as? [String : Any])?["data"] as? [String : Any])
                    let metaData = ((JSON as? [String : Any])?["meta"] as? [String : String])
                    if let type = metaData?["user_type"], let token = metaData?["token"], let userData = userData {
                        let objectData = ["user" : userData]
                        if type == "client" {
                            UserDefaults.standard.set(true, forKey:"isClient")
                            user = Client(JSON: objectData)
                        }
                        User.shared.token = token
                        
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        User.getFireBaseToken(completion: completion)
                        //}
                    }
                    
                case .failure(let serverError):
                    error = serverError.psError
                }
            }
            completion(user, error)
        }
    }
    
    @discardableResult
    func login(email: String, password: String, completion: @escaping LoginCompletion) -> DataRequest? {
        let request = Request.login(parameters: ["email": email,
                                                 "password": password])
        //TODO: add error handling
        SVProgressHUD.show()
        return self.service.request(request: request).responseJSON { (response) in
            SVProgressHUD.dismiss()
            var error: ErrorProtocol?
            var user: User?
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                switch response.result {
                case .success(let JSON):
                    let userData = ((JSON as? [String : Any])?["data"] as? [String : Any])
                    let metaData = ((JSON as? [String : Any])?["meta"] as? [String : String])
                    if let type = metaData?["user_type"], let token = metaData?["token"], let userData = userData {
                        let objectData = ["user" : userData]
                        if type == "trainer" {
                            UserDefaults.standard.set(false, forKey:"isClient")
                            user = Trainer(JSON: objectData)
                        } else if type == "client" {
                            UserDefaults.standard.set(true, forKey:"isClient")
                            user = Client(JSON: objectData)
                        }
                        User.shared.token = token
        
                            User.getFireBaseToken(completion: { (user, error) in
                                
                            })
                    }
                    
                case .failure(let serverError):
                    error = serverError.psError
                }
            }
            completion(user, error)
        }
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
    func getUserInfo(completion: @escaping GetUserInfoCompletion) -> DataRequest? {
        let request = Request.getUserInfo()
        
        //TODO: remove copypaste
        SVProgressHUD.show()
        return self.service.request(request: request).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            var error: ErrorProtocol?
            var user: User?
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                switch response.result {
                case .success(let JSON):
                    let userData = ((JSON as? [String : Any])?["data"] as? [String : Any])
                    let metaData = ((JSON as? [String : Any])?["meta"] as? [String : String])
                    if let type = metaData?["user_type"], let userData = userData {
                        let objectData = ["user" : userData]
                        if let name = userData["name"] as? String, let email =  userData["email"] as? String {
                            User.shared.name = name
                            User.shared.email = email
                            if let avatar = userData["avatar"] as? String {
                                User.shared.avatar = avatar
                            }
                        }
                    }
                    
                case .failure(let serverError):
                    error = serverError.psError
                }
            }
            completion(user, error)
        }
        
    }
    
    @discardableResult
    func getTrainers(completion: @escaping GetTrainersCompletion) -> DataRequest? {
        let request = Request.getTrainers()
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Trainer]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    func uploadAvatar(data: Data, completion: @escaping ChangeAvatarCompletion) {
        guard let token = User.shared.token else {return}
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "avatar", fileName: "image.jpg", mimeType: "image/jpeg")
                
        },
            to: PSURL.BaseURL + "/v1/settings/avatar", method : .post, headers: ["Authorization" : "Bearer" + token],
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
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Template]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func getTemplateWithExercises(templateId: String, completion: @escaping GetTemplateWithExercises) -> DataRequest? {
        let request = Request.getTemplateWithExercise(templateId: templateId)
        return self.perform(request)?.responseObject(keyPath: "data") { (response: DataResponse<Template>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func deleteTemplate(templateId: String, personalData: [String: Any], completion: @escaping DeleteTemplateCompletion) -> DataRequest?{
        let request = Request.deleteTemplate(templateId: templateId, parameters: personalData)
        return self.simple(request: request, completion: completion)
    }
    
    @discardableResult
    func getAllClients(completion: @escaping GetAllClientsComletion) -> DataRequest? {
        let request = Request.getAllClients()
        
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Client]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func getTrainerEvents(startDate: String, endDate: String, completion: @escaping GetTrainerEvents) -> DataRequest? {
        let request = Request.getTrainerEvents(startDate: startDate, endDate: endDate)
        
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Event]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func getClientEvents(startDate: String, endDate: String, completion: @escaping GetClientEvents) -> DataRequest? {
        let request = Request.getClientEvents(startDate: startDate, endDate: endDate)
        
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Event]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func createEvent(eventData: [String: Any], completion: @escaping CreateEventCompletion) -> DataRequest? {
        let request = Request.createEvent(parameters: eventData)
        return self.simple(request: request, completion: completion)
    }
    
    @discardableResult
    func getWorkouts(completion: @escaping GetWorkoutsCompletion) -> DataRequest? {
        let request = Request.getWorkouts()
        return self.perform(request)?.responseArray(keyPath: "data") { (response: DataResponse<[Workout]>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func getWorkoutById(workoutId: String, completion: @escaping GetWorkoutByIdCompletion) -> DataRequest? {
        let request = Request.getWorkoutById(workoutId: workoutId)
        return self.perform(request)?.responseObject(keyPath: "data") { (response: DataResponse<Workout>) in
            var error: ErrorProtocol?
            if let responseError = self.handle(response: response) {
                error = responseError
            }
            completion(response.result.value, error)
        }
    }
    
    @discardableResult
    func submitWorkout(workoutId: String, completion: @escaping SubmitWorkOutCompletion) -> DataRequest? {
        let request = Request.submitWorkout(workoutId: workoutId)
        return self.simple(request: request, completion: completion)?.validate()
    }
    
    @discardableResult
    func assignTemaplate(clientId: String, templateId: String, completion: @escaping AssignTemplateCompletion) -> DataRequest? {
        let request = Request.assignTemplate(clientId: clientId, templateId: templateId, parameters: [:])
        return self.simple(request: request, completion: completion)?.validate()
    }
    
    @discardableResult
    func getFireBaseToken(completion: @escaping GetFireBaseTokenCompletion) -> DataRequest? {
        let request = Request.getFireBaseToken()
        return self.perform(request)?.responseJSON { (response) in
            var error: ErrorProtocol?
            var user: User?
            if response.response?.statusCode == 202 {
                User.getFireBaseToken(completion: completion)
                return
            }
            if let responseError = self.handle(response: response) {
                error = responseError
            } else {
                switch response.result {
                case .success(let JSON):
                    
                    let metaData = ((JSON as? [String : Any])?["meta"] as? [String : String])
                    if let token = metaData?["token"] {
                   
                        User.shared.firToken = token
                        
                        Auth.auth().signIn(withCustomToken:  token) { (user, error) in
                            
                        }
                    }
                case .failure(let serverError):
                    error = serverError.psError
                }
            }
            completion(user, error)
        }
    }
}

extension PSAPI {
    
    //MARK: Typelias
    
    typealias RefreshTokenCompletion    = (_ error: ErrorProtocol?) -> Void
    
    typealias RegisterTrainerCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias RegisterClientCompletion  = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias LoginCompletion           = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias ForgotPassword            = (_ error: ErrorProtocol?) -> Void
    
    typealias SetPasswordCompletion     = (_ error: ErrorProtocol?) -> Void
    
    typealias ChangePasswordCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias ChangeAvatarCompletion    = (_ error: ErrorProtocol?) -> Void
    
    typealias GetTrainersCompletion     = (_ user: [Trainer]?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateTemplateCompletion  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias EditTemplateCompletion    = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias GetAllTemplatesCompletion = (_ template: [Template]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTemplateWithExercises  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias DeleteTemplateCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias GetAllClientsComletion    = (_ client: [Client]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTrainerEvents          = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetClientEvents           = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    typealias CreateEventCompletion     = (_ error: ErrorProtocol?) -> Void
    
    typealias GetWorkoutsCompletion     = (_ workout: [Workout]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetWorkoutByIdCompletion = (_ workout: Workout?, _ error: ErrorProtocol?) -> Void
    
    typealias AssignTemplateCompletion  = (_ error: ErrorProtocol?) -> Void
    
    typealias SubmitWorkOutCompletion   = (_ error: ErrorProtocol?) -> Void
    
    typealias GetUserInfoCompletion     = (_ user: User?, _ error: ErrorProtocol?) -> Void
    
    typealias GetFireBaseTokenCompletion = (_ user: User?, _ error: ErrorProtocol?) -> Void
}
