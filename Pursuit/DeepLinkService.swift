//
//  DeepLinkService.swift
//  CameraRecordingApp
//
//  Created by Igor on 6/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import DeepLinkKit

protocol DeepLinkService {
    var pattern: String { get }
    
    func received(link: DPLDeepLink?, controller: UIViewController?)
}

extension DPLDeepLinkRouter {
    
    private static var tasksGroupKey: UInt8 = 0
    var tasksGroup: DispatchGroup {
        get {
            if let group = objc_getAssociatedObject(self, &DPLDeepLinkRouter.tasksGroupKey) as? DispatchGroup {
                return group
            }
            let group = DispatchGroup()
            objc_setAssociatedObject(self, &DPLDeepLinkRouter.tasksGroupKey, group, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return group
        }
    }
    
    class Task {
        fileprivate var group: DispatchGroup?
        
        fileprivate init(group: DispatchGroup) {
            self.group = group
            self.group?.enter()
        }
        
        func end() {
            self.group?.leave()
        }
    }
    
    func addTask() -> DPLDeepLinkRouter.Task {
        return Task(group: self.tasksGroup)
    }
    
    func register(service: DeepLinkService) {
        self.register({ (link) in
            self.tasksGroup.notify(queue: .main) {
                let controller = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first
                
                service.received(link: link, controller: controller)
            }
        }, forRoute: service.pattern)
    }
}
