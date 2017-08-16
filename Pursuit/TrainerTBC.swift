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
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC")
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "TemplatesVC")
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "ClientsTableView")
        
        v1!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_schedule"), selectedImage: UIImage(named: "ic_schedule"))
        v2!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_pursuit")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_pursuit")?.withRenderingMode(.alwaysOriginal))
        v3!.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: nil, image: UIImage(named: "ic_list"), selectedImage: UIImage(named: "ic_list"))
        
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.barTintColor = UIColor(white: 255/255.0, alpha: 0.1)
        
        //self.viewControllers = [v1!, v2!, v3!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func setTitle(text: String) {
//        self.title = "Testing"
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect(x: 0, y: 0, width: 80.0, height: 65.0)
//        titleLabel.font = UIFont(name: "Avenir-Book", size: 17.0)
//        titleLabel.textColor = UIColor(white: 255.0/255.0, alpha: 1.0)
//        titleLabel.sizeToFit()
//        titleLabel.text = text
//        
//        let leftItem = UIBarButtonItem(customView: titleLabel)
//        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftItem
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
