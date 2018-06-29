//
//  ClientRequestsVC.swift
//  Pursuit
//
//  Created by ігор on 6/28/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import EmptyKit

protocol ClientsRequestsVCDelegate: class {
    func dismiss(controller: ClientsRequestsVC)
}

class ClientsRequestsVC: UIViewController {

    @IBOutlet weak var requestsSearchBar: UISearchBar! {
        didSet {
            requestsSearchBar.backgroundImage    = UIImage()
            requestsSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            requestsSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = requestsSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                
            }
        }
    }
    @IBOutlet weak var requestsTableView: UITableView!  {
        didSet {
            self.requestsTableView.ept.dataSource = self
        }
    }
    
    weak var delegate: ClientsRequestsVCDelegate?
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        delegate?.dismiss(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
        
       navigationController?.navigationBar.setAppearence()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}

extension ClientsRequestsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientRequestsTableViewCell.self) else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension ClientsRequestsVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "No Clients Requests"
    }
    
    var emptyImageName: String {
        return "no_clients_empty_dataset"
    }
    
    var fontSize: CGFloat {
        return 32.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}

