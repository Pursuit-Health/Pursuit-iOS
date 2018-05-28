//
//  SavedTemplateModel+API.swift
//  Pursuit
//
//  Created by Igor on 5/24/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

extension SavedTemplateModel {
    
    typealias SaveSavedTemplateCompletion   = (_ error: ErrorProtocol?) -> Void
    typealias EditSavedTemplateCompletion   = (_ error: ErrorProtocol?) -> Void
    typealias DeleteSavedTemplateCompletion = (_ error: ErrorProtocol?) -> Void
    
    class func saveSavedTemplate(template: SavedTemplateModel, completion: @escaping  SaveSavedTemplateCompletion) {
        let api = PSAPI()
        api.saveSavedTemplate(templateData: template.toJSON(), completion: completion)
    }
    
    class func editSavedTemplate(templateId: String, template: SavedTemplateModel, completion: @escaping  EditSavedTemplateCompletion) {
        let api = PSAPI()
        api.editSavedTemplate(templateId: templateId, templateData: template.toJSON(), completion: completion)
    }
    
    class func deleteSavedTemplate(templateId: String, completion: @escaping DeleteSavedTemplateCompletion) {
        let api = PSAPI()
        api.deleteSavedTemplate(templateId: templateId, completion: completion)
    }
}
