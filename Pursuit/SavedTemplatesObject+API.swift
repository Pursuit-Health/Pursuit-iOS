//
//  SavedTemplate+API.swift
//  Pursuit
//
//  Created by Igor on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

typealias GetSavedTemplatesCompletion = (_ savedTemplates: SavedTemplatesObject?, _ error: ErrorProtocol?) -> Void

extension SavedTemplatesObject {
    class func getSavedTemplatesBy(namePhrase: String, page: Int, completion: @escaping GetSavedTemplatesCompletion) {
        let api = PSAPI()
        api.showProgress = false
        api.getSavedTemplates(templateNamePhrase: namePhrase, page: page, completion: completion)
    }
}
