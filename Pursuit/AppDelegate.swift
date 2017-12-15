//
//  AppDelegate.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import DeepLinkKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Properties
    
    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter?     = DPLDeepLinkRouter()
    var services: [DeepLinkService]         = [GuestDeepLinkService()]
    
    //MARK: Private.Properties
    
    private var deepLinking: Bool = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setUpTabBarAppearens()
        
        setupDeepLinking()
        
        navigateControllers()
        
        IQKeyboardManager.sharedManager().enable = true
        
        setUpStatusBarAppearence()
        
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
    
     func setUpStatusBarAppearence() {
        UIApplication.shared.delegate?.window!?.windowLevel = UIWindowLevelStatusBar
        UIApplication.shared.isStatusBarHidden = true
        let view = TopStatusBarView()
        view.frame = (UIApplication.shared.statusBarView?.frame)!
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        window?.addSubview(view)
    }

    
    private func navigateControllers() {
        var rootController = UIViewController()
        if self.checkIfUserLoggedIn() {
            guard let controller = UIStoryboard.sideMenu.SideMenuNavigation else { return }
            rootController = controller

        }else {
            guard  let controller = UIStoryboard.login.preloadNavigation else { return }
            rootController = controller
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    }
    
    private func checkIfUserLoggedIn() -> Bool {
        return User.shared.token != nil
    }
    
    private func setupDeepLinking() {

        self.services.forEach{ self.router?.register(service: $0) }
    }
    
    func setUpTabBarAppearens() {
        let tabBar = UITabBar.appearance()
        //tabBar.barTintColor = .red
        tabBar.isTranslucent = true

        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = .white
        tabBar.backgroundColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
}

