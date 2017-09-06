//
//  AppDelegate.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DeepLinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Properties
    
    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter?     = DPLDeepLinkRouter()
    var services: [DeepLinkService]         = [GuestDeepLinkService()]
    
    //MARK: Private.Properties
    
    private var deepLinking: Bool = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        setUpTabBarAppearens()
        
        setupDeepLinking()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return self.router?.handle(url, withCompletion: { (handled, error) in
            if handled && error == nil {
                self.deepLinking = true
            }
        }) ?? true
    }
    
    //MARK: Private
    
    private func setupDeepLinking() {

        self.services.forEach{ self.router?.register(service: $0) }
    }
    
    func setUpTabBarAppearens() {
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        let view = UIView()
        view.bounds = tabBar.frame
        view.backgroundColor = .red
        tabBar.addSubview(view)
    }
}

