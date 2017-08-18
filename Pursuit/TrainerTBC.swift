//
//  TrainerTBC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 5/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TrainerTBC: ESTabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TODO: Move to external methos
        //We will be not use this class
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC")
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "TemplatesVC")
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "ClientsTableView")
        
        v1!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_schedule"), selectedImage: UIImage(named: "ic_schedule"))
        v2!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_pursuit")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_pursuit")?.withRenderingMode(.alwaysOriginal))
        v3!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_list"), selectedImage: UIImage(named: "ic_list"))
        
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.barTintColor = UIColor(white: 255/255.0, alpha: 0.1)
        
        self.viewControllers = [v1!, v2!, v3!]
    }
}
