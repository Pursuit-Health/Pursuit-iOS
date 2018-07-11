//
//  TrainerTabBarVC.swift
//  Pursuit
//
//  Created by Igor on 9/25/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainerTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tabBar.tintColor        = .white
        
        if let scheduleVC = (self.viewControllers?[0] as? UINavigationController)?.visibleViewController as? ScheduleVC {
            scheduleVC.datasource = self
            
        }
    }
}

extension TrainerTabBarVC: ClientScheduleDataSource {
    typealias EventsCompletion = (_ event: [Event]?, _ error: ErrorProtocol?) -> Void
    
    func updateDataSource(_ schedule: ScheduleVC, _ startDate: String, endDate: String, complation: @escaping EventsCompletion) {
        Trainer.getTrainerEvents(startdDate: startDate, endDate: endDate) { (events, error) in
            if error == nil {
                complation(events, error)
            }else {
                complation(nil, error)
            }
        }
    }
}


extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = window.safeAreaInsets.bottom + 70
        } else {
            sizeThatFits.height = 70
        }
        return sizeThatFits
    }
}
