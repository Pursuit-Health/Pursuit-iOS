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
    
    weak var delegate: MainAuthVCDelegate?
    
    
    @IBOutlet weak var viewForPageController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getControllers()
        
    }
        
    //MARK: Private
    
    private func getControllers(){
        let controller = TabPageViewController.create()
        
        //TODO: Duplication storyboard, make one veriable storyboard
        let vc1 = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignInVCID")
        let vc2 = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpVCID")
        controller.tabItems = [(vc1, "SignIn"), (vc2, "SignUp")]
        
        setUpOptions(controller)
        
        setUpControllerToMainView(controller)
        
    }
    
    //TODO: tabulation
    private func setUpOptions(_ controller: TabPageViewController){
        var option = TabPageOption()
        option.currentBarHeight = 3.0
        option.tabWidth = view.frame.width / CGFloat(controller.tabItems.count)
        option.tabBackgroundColor = .clear
        option.currentColor = UIColor.customAuthButtons()
        controller.option = option
    }
    
    private func setUpControllerToMainView(_ controller: TabPageViewController){
        addChildViewController(controller)
        self.viewForPageController.addSubview(controller.view)
        self.viewForPageController.addConstraints(UIView.place(controller.view, onOtherView: viewForPageController))
        
        controller.didMove(toParentViewController: self)
    }
}


