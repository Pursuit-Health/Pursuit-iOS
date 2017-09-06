//
//  SelectTrainerVC.swift
//  Pursuit
//
//  Created by ігор on 9/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SelectTrainerVCDelegate: class {
    func trainerSelectedWithId(_ id: Int)
}
//IGOR: Check
class SelectTrainerVC: UIViewController {
    
    //MARK: Variables
    
    weak var delegate: SelectTrainerVCDelegate?
    
    //MARK: IBActions
    
    @IBAction func selectTrainer(_ sender: Any) {
        delegate?.trainerSelectedWithId(1999999)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
