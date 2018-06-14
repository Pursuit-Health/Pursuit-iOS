//
//  ClientTabBarVC.swift
//  Pursuit
//
//  Created by Igor on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ClientTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .white
        
        if let scheduleVC = (self.viewControllers?[0] as? UINavigationController)?.visibleViewController as? ScheduleVC {
        scheduleVC.datasource = self
        }
        if let clientInfoVC = (self.viewControllers?[1] as? UINavigationController)?.visibleViewController as? ClientInfoVC {
            clientInfoVC.dataSource = self
        }
    }
}

extension ClientTabBarVC: ClientScheduleDataSource {
    typealias EventsCompletion = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
     func updateDataSource(_ schedule: ScheduleVC, _ startDate: String, endDate: String, complation: @escaping EventsCompletion) {
        Client.getClientEvents(startdDate: startDate, endDate: endDate) { (events, error) in
            if error == nil {
                complation(events, error)
            }
        }
    }
}

extension ClientTabBarVC: ClientInfoVCDatasource {
    func loadInfo(controller: ClientInfoVC, completion: @escaping (User, [Workout]?) -> Void) {
        Workout.getWorkouts { (workouts, error) in
            if error == nil {
                if let work = workouts {
                    completion(User.shared, work)
                }
            }
        }
    }
}
