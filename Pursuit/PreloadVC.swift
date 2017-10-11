//
//  PreloadVC.swift
//  CameraRecordingApp
//
//  Created by volodymyrkhmil on 4/18/17.
//  Copyright © 2017 Userfeel LTD. All rights reserved.
//

import UIKit

class PreloadVC: UIViewController {
    
    //MARK: Properties
    
    
    ///MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareNavigation()
    }
    
    //MARK: Private.Methods
    
    private func prepareNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
