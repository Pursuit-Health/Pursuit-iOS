//
//  TemplatesVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 6/1/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TemplatesVC: UIViewController {
    
    //MARK: Constant
    
    //MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
   
    //MARK: Private
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension TemplatesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TemplateCell.self) else { return UITableViewCell() }
        return cell
    }
    
}
