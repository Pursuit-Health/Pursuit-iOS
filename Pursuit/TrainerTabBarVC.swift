//
//  TrainerTabBarVC.swift
//  Pursuit
//
//  Created by ігор on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainerTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scheduleVC = (self.viewControllers?[0] as? UINavigationController)?.visibleViewController as? ScheduleVC {
            scheduleVC.datasource = self
            
        }
        
        
        //TODO: Check
        if let templatesVC = (self.viewControllers?[1] as? UINavigationController)?.visibleViewController as? TemplatesVC {
            
        }
    }
}

extension TrainerTabBarVC: ClientScheduleDataSource {
    typealias EventsCompletion = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    func updateDataSource(_ schedule: ScheduleVC, _ startDate: String, endDate: String, complation: @escaping EventsCompletion) {
        Trainer.getTrainerEvents(startdDate: startDate, endDate: endDate) { (events, error) in
            if error == nil {
                complation(events, error)
            }
        }
    }
}
