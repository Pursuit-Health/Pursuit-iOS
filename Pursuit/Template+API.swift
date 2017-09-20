//
//  Template+API.swift
//  Pursuit
//
//  Created by ігор on 9/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

//IGOR: Check
extension Template {
    
    //MARK: Tepealias
    typealias CreateTemplateCompletion  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias EditTemplateCompletion    = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias GetAllTemplatesCompletion = (_ template: [Template]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetTemplateWithExercises  = (_ template: Template?, _ error: ErrorProtocol?) -> Void
    
    typealias DeleteTemplateCompletion  = (_ error: ErrorProtocol?) -> Void
    
   class func createTemplate(templateData: Template, completion: @escaping CreateTemplateCompletion) {
        let api = PSAPI()
        
        api.createTemplate(templateData: templateData.toJSON(), completion: completion)
    }
    
  class  func editTemplate(templateId: String, templateData: Template, completion: @escaping EditTemplateCompletion) {
        let api = PSAPI()
        
        api.editTemplate(templateId: templateId, templateData: templateData.toJSON(), completion: completion)
    }
    
    class func getAllTemplates(completion: @escaping GetAllTemplatesCompletion) {
        let api = PSAPI()
        
        api.getAllTemplates(completion: completion)
    }
    
    class func getTemplateWithExercises(templateId: String, completion: @escaping GetTemplateWithExercises) {
        let api = PSAPI()
        
        api.getTemplateWithExercises(templateId: templateId, completion: completion)
    }
    
    class func deleteTemplate(templateId: String, personalData: User, completion: @escaping DeleteTemplateCompletion) {
        let api = PSAPI()
        
        api.deleteTemplate(templateId: templateId, personalData: personalData.toJSON(), completion: completion)
    }
    
}
