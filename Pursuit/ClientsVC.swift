//
//  ClientsTableView.swift
//  Pursuit
//
//  Created by danz on 5/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit
import SDWebImage
import SVProgressHUD
import EmptyKit
import SimpleAlert

protocol ClientsVCDelegate: class {
    func didSelect(client: Client, on controller: ClientsVC)
    func showSavedTemplatesVC(on controller: ClientsVC)
}

class ClientsVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var clientsTable: UITableView! {
        didSet {
           self.clientsTable.ept.dataSource = self
        }
    }
    
    @IBOutlet weak var clientsSearchBar: UISearchBar! {
        didSet {
            clientsSearchBar.backgroundImage    = UIImage()
            clientsSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            clientsSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = clientsSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                
            }
        }
    }

    //MARK: Variables
    
    weak var delegate: ClientsVCDelegate?
    
    var savedTemplatesCoordinator: SavedTemplatesCoordinator = SavedTemplatesCoordinator()
    
    
    lazy var assignTemplateVC: AssignTemplateVC? = {
        
        guard let controller = UIStoryboard.trainer.AssignTemplate else { return UIViewController() as? AssignTemplateVC }
        
        return controller
    }()
    
    lazy var clientScheduleVC: ScheduleClientVC? = {
        guard let controller = UIStoryboard.trainer.ScheduleClient else { return UIViewController() as? ScheduleClientVC }
        
        return controller
    }()
    
    var client: [Client] = []
    
    var filteredClients: [Client] = [] {
        didSet {
            self.clientsTable.reloadData()
        }
    }
    
    private var isEditingTableView: Bool = false {
        didSet {
            clientsTable.isEditing = isEditingTableView
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: Any) {
        isEditingTableView = !isEditingTableView
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullToRefresh()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
        
        configureSideMenuController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func showSavedTemplatesVC() {
        self.savedTemplatesCoordinator.start(from: self)
    }
    
    private func addPullToRefresh() {
        self.clientsTable.addPullRefresh { [weak self] in
            self?.loadClients()
        }
        self.clientsTable.startPullRefresh()
    }
    
    private func configureSideMenuController() {
        if self.revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    private func showPaymentRequiredAlert(on controller: UIViewController, with title: String, message: String) {
        let action = PSAlert(title: title, message: title, style: .alert).addActionHandler(action: AlertAction(title: "Cancel", style: .default, handler: { _ in
            
        })).addActionHandler(action: AlertAction(title: "View Plans", style: .default, handler: { _ in
            let subscriptionPlans = UIStoryboard.trainer.SubscriptionPlans!
            
            controller.navigationController?.pushViewController(subscriptionPlans, animated: true)
        }))
        controller.present(action, animated: true, completion: nil)
    }
    
    private func handleError(error: ErrorProtocol) {
        if error.statusCode == AppCoordinator.AuthError.paymentrequired.rawValue || error.statusCode == AppCoordinator.AuthError.subscriptionExpired.rawValue {
            let authError = AppCoordinator.AuthError(rawValue: error.statusCode) ?? .none
            
            self.showPaymentRequiredAlert(on: self, with: authError.leftTitle, message: authError.message)
        }else {
            let alert = error.alert(action: UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func loadClients(){
        Client.getAllClients(completion: { trainersInfo, error in
            self.clientsTable.stopPullRefreshEver()
            if let error = error {
                self.handleError(error: error)
            }else {
                if let data = trainersInfo {
                    self.client             = data
                    self.filteredClients    = data
                }
            }
        })
    }
    
    fileprivate func confirmDeleteClientAt(_ index: Int) {
        let alert = UIAlertController(title: "Delete Client", message: "Do you want to delete Client?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteClientAt(index)
        }
        
        let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteClientAt(_ index: Int) {
        if filteredClients.count < index {
            return
        }
        let client = filteredClients[index]
        Trainer.deleteClient(clientId: "\(client.id ?? 0)") { (error) in
            if let error = error {
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                self.loadClients()
            }
        }
    }
}

extension ClientsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredClients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientCell.self) else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        
        let clientData = filteredClients[indexPath.row]
        if let url = clientData.clientAvatar {
            cell.clientImage.sd_setImage(with: URL(string: url.persuitImageUrl()))            
        }else {
            cell.clientImage.image = UIImage(named: "user")
        }
        
        cell.clientName.text = clientData.name
        
        cell.clientImage.clipsToBounds = true;
        
        //changes cell text color
        cell.clientName.textColor = UIColor.white;
        
        //cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteClientAt(indexPath.row)
        }
    }
}

extension ClientsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        User.shared.coordinator?.start(from: self, with: self.filteredClients[indexPath.row])
    }
}

extension ClientsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredClients = self.client
        }else {
            self.filteredClients = self.client.filter{ $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
        searchBar.resignFirstResponder()
    }
}

extension ClientsVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "No Clients"
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
