//
//  Workout+API.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension Workout {
    
    typealias GetWorkoutsCompletion = (_ event: [Workout]?, _ error: ErrorProtocol?) -> Void
    
    typealias GetWorkoutByIdCompletion = (_ workout: Workout?, _ error: ErrorProtocol?) -> Void
    
    class func getWorkouts(completion: @escaping GetWorkoutsCompletion) {
        let api = PSAPI()
        
        api.getWorkouts(completion: completion)
    }
    
    class func getWorkoutById(workoutId: String, completion: @escaping GetWorkoutByIdCompletion) {
        let api = PSAPI()
        
        api.getWorkoutById(workoutId: workoutId, completion: completion)
    }
}
