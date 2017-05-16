//
//  Transitions.swift
//  CoachX
//
//  Created by Kent Guerriero on 1/23/17.
//  Copyright © 2017 Dezapp. All rights reserved.
//

import Foundation
import UIKit
//import RESideMenu
//import FirebaseAuth
class Transitions : NSObject {
    static func presentMain(){
        let storyboard = UIStoryboard(name: "TrainerMain", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")
        self.present(controller, animated: true, completion: nil)
        UIApplication.shared.delegate?.window??.rootViewController = sideMenuController
    }
//    
//    static func logout() -> Bool {
//        var success = true
//        do {
//            try FIRAuth.auth()?.signOut()
//            let sbLogin = UIStoryboard(name: "Login", bundle: nil)
//            let loginVC = sbLogin.instantiateViewController(withIdentifier: "LoginVC")
//            UIApplication.shared.delegate?.window??.rootViewController = loginVC
//        } catch  {
//            success = false
//        }
//        return success
//    }
}
