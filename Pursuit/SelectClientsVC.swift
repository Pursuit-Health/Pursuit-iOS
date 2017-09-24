//
//  SelectClientsVC.swift
//  Pursuit
//
//  Created by ігор on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

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
    
    
    @IBOutlet weak var clientSearchBar: UISearchBar! {
        didSet {
            clientSearchBar.backgroundImage    = UIImage()
            if let searchField = clientSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "m", size: 15)
            }
        }
    }
    
    //MARK: Variables
    
    var client: [Client] = []
    
    var filteredClients: [Client] = [] {
        didSet {
            self.selectClientCollectionView.reloadData()
        }
    }
    
    var selectedClients: [Int] = []
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
        
        loadTrainers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setAppearence()
        navigationController?.navigationBar.isHidden = false
    }
}

extension SelectClientsVC {
    
    fileprivate func loadTrainers(){
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
        cell.clientPhotoImageView.image = UIImage(named: "avatar1")
        cell.clientNameLabel.text = clientData.name
        
        return cell
    }
}

extension SelectClientsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectClientCell else {
            return
        }
        
        cell.clientSelected = true
        
        let clientData = filteredClients[indexPath.row]
        
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
            self.filteredClients = self.client.filter{ $0.name?.contains(searchText) ?? false }
        }
    }
}
