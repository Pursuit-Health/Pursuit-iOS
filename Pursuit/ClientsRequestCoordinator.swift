//
//  ClientsRequestCoordinator.swift
//  Pursuit
//
//  Created by ігор on 6/28/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

class ClientsRequestCoordinator: Coordinator {
    
    func start(from controller: UIViewController?) {
        
        let clientsRequest = UIStoryboard.trainer.ClientsRequests!
        let nav = UINavigationController(rootViewController: clientsRequest)
        clientsRequest.delegate = self
        controller?.present(nav, animated: true, completion: nil)
    }
}

extension ClientsRequestCoordinator: ClientsRequestsVCDelegate {
    func dismiss(controller: ClientsRequestsVC) {
        controller.dismiss(animated: true, completion: nil)
    }
}
