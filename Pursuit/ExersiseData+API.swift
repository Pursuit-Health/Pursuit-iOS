//
//  ExersiseData+API.swift
//  Pursuit
//
//  Created by ігор on 1/25/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

extension ExcersiseData {
    
    typealias SearchExerciseCompletion = (_ exercises: [ExcersiseData.InnerExcersise]?, _ error: ErrorProtocol?) -> Void

    class func searchExercise(phrase: String, completion: @escaping SearchExerciseCompletion) {
        let api = PSAPI()
        api.searchExercises(phrase: phrase, completion: completion)
    }
}
