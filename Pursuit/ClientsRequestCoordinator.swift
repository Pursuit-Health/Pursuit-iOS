//
//  ClientsRequestCoordinator.swift
//  Pursuit
//
//  Created by ігор on 6/28/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation
import SVProgressHUD
import SimpleAlert

class ClientsRequestCoordinator: Coordinator {
    
    func start(from controller: UIViewController?) {
        
        let clientsRequest = UIStoryboard.trainer.ClientsRequests!
        let nav = UINavigationController(rootViewController: clientsRequest)
        clientsRequest.delegate = self
        clientsRequest.datasource = self
        controller?.present(nav, animated: true, completion: nil)
    }
    
    fileprivate func showPaymentRequiredAlert(on controller: UIViewController, title: String, message: String) {
        let action = PSAlert(title: title, message: message, style: .alert).addActionHandler(action: AlertAction(title: "Cancel", style: .default, handler: { _ in
            
            
        })).addActionHandler(action: AlertAction(title: "View Plans", style: .default, handler: { _ in
            let subscriptionPlans = UIStoryboard.trainer.SubscriptionPlans!
            
            controller.navigationController?.pushViewController(subscriptionPlans, animated: true)
        }))
        controller.present(action, animated: true, completion: nil)
    }
    
    fileprivate func hanleError(error: ErrorProtocol, on controller: UIViewController) {
        if error.statusCode == AppCoordinator.AuthError.paymentrequired.rawValue || error.statusCode == AppCoordinator.AuthError.subscriptionExpired.rawValue {
            let authError = AppCoordinator.AuthError(rawValue: error.statusCode) ?? .none
            self.showPaymentRequiredAlert(on: controller, title: authError.leftTitle, message: authError.message)
        }else {
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.present(error.alert(action: alertAction), animated: true, completion: nil)
        }
    }
}

extension ClientsRequestCoordinator: ClientsRequestsVCDelegate, ClientsRequestsVCDatasource {
    func acceptClient(client: Client, on controller: ClientsRequestsVC) {
        Trainer.acceptClient(clientId: "\(client.id ?? 0)") { (error) in
            if let error = error {
                self.hanleError(error: error, on: controller)
            }else {
                controller.updateDatasource()
            }
        }
    }
    
    func rejectClient(client: Client, on controller: ClientsRequestsVC) {
        Trainer.rejectClient(clientId: "\(client.id ?? 0)") { (error) in
            if let error = error {
                self.hanleError(error: error, on: controller)
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
                self.hanleError(error: error, on: controller)
            }else {
                completion(clients)
            }
        }
    }
}
