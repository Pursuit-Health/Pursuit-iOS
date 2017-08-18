//
//  LoginVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import KVNProgress

protocol MainAuthVCDelegate: class {
    func signUpButtonPressedMainAuthVC()
    func signInButtonPressedMainAuthVC()
}

class MainAuthVC: UIViewController {
    
    //MARK: Variables
    
    weak var delegate: MainAuthVCDelegate?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var viewForPageController: UIView!
    
    //MARK: LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getControllers()
        
    }
        
    //MARK: Private
    
    private func getControllers(){
        let controller = TabPageViewController.create()
        
        //TODO: Duplication storyboard, make one veriable storyboard
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        let signInVC = loginStoryboard.instantiateViewController(withIdentifier: "SignInVCID")
        let signUpVC = loginStoryboard.instantiateViewController(withIdentifier: "SignUpVCID")
        
        controller.tabItems = [(signInVC, "SignIn"), (signUpVC, "SignUp")]
        
        setUpOptions(controller)
        
        setUpControllerToMainView(controller)
        
    }
    
    //TODO: tabulation
    private func setUpOptions(_ controller: TabPageViewController) {
        var option                  = TabPageOption()
        option.currentBarHeight     = 3.0
        option.tabWidth             = view.frame.width / CGFloat(controller.tabItems.count)
        option.tabBackgroundColor   = .clear
        option.currentColor         = UIColor.customAuthButtons()
        controller.option           = option
    }
    
    private func setUpControllerToMainView(_ controller: TabPageViewController) {
        addChildViewController(controller)
        self.viewForPageController.addSubview(controller.view)
        self.viewForPageController.addConstraints(UIView.place(controller.view, onOtherView: viewForPageController))
        
        controller.didMove(toParentViewController: self)
    }
}


