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
    func acceptClient(client: Client, on controller: ClientsRequestsVC)
    func rejectClient(client: Client, on controller: ClientsRequestsVC)
}

protocol ClientsRequestsVCDatasource: class {
    func loadClientsRequests(on controller: ClientsRequestsVC, completion: @escaping (_ clients: [Client]?) -> Void)
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
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        delegate?.dismiss(controller: self)
    }
    
    //MARK: Variables
    
    weak var delegate: ClientsRequestsVCDelegate?
    weak var datasource: ClientsRequestsVCDatasource?
    
    private var clients: [Client] = []
    
    var filteredClients: [Client] = [] {
        didSet {
            requestsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
        
       navigationController?.navigationBar.setAppearence()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        updateDatasource()
    }
    
    func updateDatasource() {
        datasource?.loadClientsRequests(on: self, completion: { (clients) in
            self.clients = clients ?? []
            self.filteredClients = clients ?? []
        })
    }
}

extension ClientsRequestsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientRequestsTableViewCell.self) else { return UITableViewCell() }
        let client = filteredClients[indexPath.row]
        cell.clientNameLabel.text = client.name
        cell.delegate = self
        if let url = client.clientAvatar {
            cell.clientImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
        }else {
            cell.clientImageView.image = UIImage(named: "user")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension ClientsRequestsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredClients = self.clients
        }else {
            self.filteredClients = self.clients.filter{ $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ClientsRequestsVC: ClientRequestsTableViewCellDelegate {
    func acceptButtonPressed(on cell: ClientRequestsTableViewCell) {
        if let indexPath = requestsTableView.indexPath(for: cell) {
            let client = filteredClients[indexPath.row]
            delegate?.acceptClient(client: client, on: self)
        }
    }
    
    func denyButtonPressed(on cell: ClientRequestsTableViewCell) {
        if let indexPath = requestsTableView.indexPath(for: cell) {
            let client = filteredClients[indexPath.row]
            delegate?.rejectClient(client: client, on: self)
        }
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

