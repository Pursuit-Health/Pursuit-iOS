//
//  SelectClientsVC.swift
//  Pursuit
//
//  Created by Igor on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SelectClientsVCDelegate: class {
    func clientSelected(_ client: Client, on controller: SelectClientsVC)
}

class SelectClientsVC: UIViewController {
    
    //MARK: Constants
    
    struct Constants {
        struct Cell {
            var nibName: String
            var identifier: String
            
            static let client = Cell(nibName: "SelectClientCell", identifier: "SelectClientCollectionViewCellReuseID")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var selectClientCollectionView: UICollectionView! {
        didSet{
            let cellData    = Constants.Cell.client
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            selectClientCollectionView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
        }
    }
    
    weak var delegate: SelectClientsVCDelegate?
    
    @IBOutlet weak var clientSearchBar: UISearchBar! {
        didSet {
            clientSearchBar.backgroundImage    = UIImage()
            clientSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            clientSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = clientSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
                guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
                
                for view in clientSearchBar.subviews {
                    for subview in view.subviews {
                        if subview.isKind(of: UISearchBarBackground) {
                            subview.alpha = 0
                        }
                    }
                }
                
            }
        }
    }
    
    //MARK: Variables
    
    var client: [Client] = []
    
    var filteredClients: [Client] = [] {
        didSet {
            self.selectClientCollectionView?.reloadData()
        }
    }
    
    var selectedClients: [Int] = []
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
        
        loadClients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setAppearence()
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension SelectClientsVC {
    
    fileprivate func loadClients(){
        Client.getAllClients(completion: { trainersInfo, error in
            if let data = trainersInfo {
                self.client             = data
                self.filteredClients    = data
            }
        })
    }
}

extension SelectClientsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredClients.count
    }
    
    //TODO: Make Bindable
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.client.identifier, for: indexPath) as? SelectClientCell else { return UICollectionViewCell() }
        let clientData = filteredClients[indexPath.row]
        
        cell.clientSelected = clientData.isSelected
        
        if let url = clientData.clientAvatar {
            cell.clientPhotoImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
        }else {
            cell.clientPhotoImageView.image = UIImage(named: "profile")
        }
        cell.clientNameLabel.text = clientData.name
        
        return cell
    }
}

extension SelectClientsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectClientCell else {
            return
        }
        //TODO:
        let clientData = filteredClients[indexPath.row]
        
        clientData.isSelected = !clientData.isSelected
        
        cell.clientSelected = clientData.isSelected
        
        delegate?.clientSelected(clientData, on: self)
        
        selectedClients.append(clientData.id ?? 0)
        
    }
}

extension SelectClientsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.selectClientCollectionView.bounds
        return CGSize(width: ((size.width - 20) / 3) - 1, height: size.width / 3)
    }
}

extension SelectClientsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredClients = self.client
        }else {
            self.filteredClients = self.client.filter{ $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
}
