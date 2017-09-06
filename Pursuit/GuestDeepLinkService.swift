//
//  GuestDeepLinkService.swift
//  CameraRecordingApp
//
//  Created by Igor on 6/28/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import DeepLinkKit
//IGOR: Check
class GuestDeepLinkService: DeepLinkService {
    
    //MARK: Private.Properties
    
    private var guestToken: String?
    
    var pattern: String {
        return "helthpersuit://.*"
    }
    
    func received(link: DPLDeepLink?, controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        guard let hash = link?.queryParameters["hash"] as? String else { return}
        
        presentResetPasswordVC(to: controller, with: hash)
    }
    
    private func presentResetPasswordVC(to controller: UIViewController, with hash: String) {
        let loginStoryboard = UIStoryboard(name: Storyboards.Login, bundle: nil)
        let navigation = loginStoryboard.instantiateViewController(withIdentifier: Controllers.Identifiers.ResetPassword)

        ResetPasswordVC.hashString = hash
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              controller.present(navigation
                , animated: true, completion: nil)
        }
    }
}
