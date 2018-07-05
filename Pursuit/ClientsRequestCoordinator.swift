//
//  ClientsRequestCoordinator.swift
//  Pursuit
//
//  Created by ігор on 6/28/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import SVProgressHUD

class ClientsRequestCoordinator: Coordinator {
    
    func start(from controller: UIViewController?) {
        
        let clientsRequest = UIStoryboard.trainer.ClientsRequests!
        let nav = UINavigationController(rootViewController: clientsRequest)
        clientsRequest.delegate = self
        clientsRequest.datasource = self
        controller?.present(nav, animated: true, completion: nil)
    }
}

extension ClientsRequestCoordinator: ClientsRequestsVCDelegate, ClientsRequestsVCDatasource {
    func acceptClient(client: Client, on controller: ClientsRequestsVC) {
        Trainer.acceptClient(clientId: "\(client.id ?? 0)") { (error) in
            if let error = error {
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                controller.present(error.alert(action: alertAction), animated: true, completion: nil)
            }else {
                controller.updateDatasource()
            }
        }
    }
    
    func rejectClient(client: Client, on controller: ClientsRequestsVC) {
        Trainer.rejectClient(clientId: "\(client.id ?? 0)") { (error) in
            if let error = error {
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                controller.present(error.alert(action: alertAction), animated: true, completion: nil)
            }else {
                controller.updateDatasource()
            }
        }
    }
    
    func dismiss(controller: ClientsRequestsVC) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func loadClientsRequests(on controller: ClientsRequestsVC, completion: @escaping ([Client]?) -> Void) {
        Trainer.getPendingClients { (clients, error) in
            if let error = error {
                completion(nil)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
               controller.present(error.alert(action: alertAction), animated: true, completion: nil)
            }else {
                completion(clients)
            }
        }
    }
}
