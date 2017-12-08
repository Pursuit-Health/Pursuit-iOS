//
//  ContainerChatVC.swift
//  Pursuit
//
//  Created by ігор on 12/8/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ContainerChatVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var chatVC: ChatVC = {
        let controller = UIStoryboard.trainer.Chat!
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChatController()
    }

    func addChatController() {
        let controller = self.chatVC
        self.containerView.addSubview(controller.view)
        self.containerView.addConstraints(UIView.place(controller.view, onOtherView: self.containerView))
        controller.didMove(toParentViewController: self)
        self.addChildViewController(controller)
    }

}
