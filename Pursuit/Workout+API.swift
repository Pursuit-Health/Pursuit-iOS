//
//  Workout+API.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

extension Workout {
    
    typealias GetWorkoutsCompletion = (_ event: [Workout]?, _ error: ErrorProtocol?) -> Void
    typealias GetClientsWorkoutDetails = (_ excercises: [ExcersiseData]?, _ error: ErrorProtocol?) -> Void
    typealias GetWorkoutByIdCompletion = (_ workout: Workout?, _ error: ErrorProtocol?) -> Void
    typealias SubmitExcersiseCompletion    = (_ error: ErrorProtocol?) -> Void
    typealias CreateWorkoutCompletion = (_ workout: Workout?, _ error: ErrorProtocol?) -> Void
    
    typealias EditWorkoutCompletion  =  (_ workout: Workout?, _ error: ErrorProtocol?) -> Void
    
    typealias DeleteWorkoutCompletion = (_ error: ErrorProtocol?) -> Void
    
    typealias DeleteWorkoutExerciseCompletion = (_ error: ErrorProtocol?) -> Void
    
    class func getWorkouts(completion: @escaping GetWorkoutsCompletion) {
        let api = PSAPI()
        api.showProgress = false
        api.getWorkouts(completion: completion)
    }
    
    class func getWorkoutById(workoutId: String, completion: @escaping GetWorkoutByIdCompletion) {
        let api = PSAPI()
        
        api.getWorkoutById(workoutId: workoutId, completion: completion)
    }
    
    func updateToClientoDetails(completion: GetClientsWorkoutDetails? = nil) {
        guard let id = self.id else {
            completion?(nil, PSError.somethingWentWrong)
            return
        }
        let api = PSAPI()
        api.getClientWorkountDetails(workoutId: id) { (excercises, error) in
            if error == nil {
                self.excersises = excercises
            }
            completion?(excercises, error)
        }
    }
    
    func submit(excersise: ExcersiseData, completion: SubmitExcersiseCompletion? = nil) {
        if let workoutId = self.id, let excersiseId = excersise.id {
            let api = PSAPI()
            api.submit(excersiseId: excersiseId, for: workoutId, completion: { (error) in
                if error == nil {
                    excersise.isDone = true
                }
                completion?(error)
            })
        } else {
            completion?(PSError.somethingWentWrong)
        }
    }
    
     func getDetailedTemplateFor(clientId: String, templateId: String, completion: @escaping GetWorkoutByIdCompletion) {
        let api = PSAPI()
        api.getDetailedTemplateFor(clietnId: clientId, templateId: templateId) { (workout, error) in
            if error == nil {
                self.excersises = workout?.workoutExercises
                 self.isDone = workout?.isDone
                
            }
            completion(workout, error)
        }
    }
    
    func createWorkout(clientId: String, completion: @escaping CreateWorkoutCompletion) {
        let api = PSAPI()
        api.createWorkout(clientId: clientId, templateData: self.toJSON(), completion: completion)
    }
    
    func editWorkout(clientId: String, templateId: String, completion: @escaping EditWorkoutCompletion) {
        let api = PSAPI()
        
        api.editTemplate(clientId: clientId, templateId: templateId, templateData: self.toJSON(), completion: completion)
    }
    
    func delete(clientId: String, completion: @escaping DeleteWorkoutCompletion) {
        let api = PSAPI()
        
        api.deleteTemplate(clientId: clientId, templateId: "\(self.id ?? 0)", completion: completion)
    }
    
    func deleteExerciseWithId(clientId: String, exerciseId: String, completion: @escaping DeleteWorkoutExerciseCompletion) {
        let api = PSAPI()
        
        api.deleteTemplateExercise(clientId: clientId, templateId: "\(self.id ?? 0)", exerciseId: exerciseId, completion: completion)
    }
}
