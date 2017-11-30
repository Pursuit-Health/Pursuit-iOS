//
//  SelectTrainerVC.swift
//  Pursuit
//
//  Created by ігор on 9/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol SelectTrainerVCDelegate: class {
    func trainerSelectedWithId(trainer: Trainer)
}
//IGOR: Check
class SelectTrainerVC: UIViewController {
    
    //MARK: Constants 
    
    struct Constants {
        struct Cell {
            var nibName: String
            var identifier: String
            
            static let trainer = Cell(nibName: "SelectTrainer", identifier: "SelectTrainerCollectionViewCellReuseID")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var selectTrainerCollectionView: UICollectionView! {
        didSet{
            let cellData    = Constants.Cell.trainer
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            selectTrainerCollectionView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
        }
    }
    
    
    @IBOutlet weak var trainerSearchBar: UISearchBar! {
        didSet {
            trainerSearchBar.backgroundImage    = UIImage()
            trainerSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = trainerSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
            }
        }
    }
    
    //MARK: Variables
    
    weak var delegate: SelectTrainerVCDelegate?
    
    var trainers: [Trainer] = []
    
    var filteredTrainers: [Trainer] = [] {
        didSet {
            self.selectTrainerCollectionView.reloadData()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        navigationController?.isNavigationBarHidden = false
    }
}

extension SelectTrainerVC {
    
     fileprivate func loadTrainers(){
        Trainer.getTrainers(completion: { trainersInfo, error in
            if let data = trainersInfo {
                self.trainers = data
                self.filteredTrainers = data
            }
        })
    }
    
    fileprivate func userDidSelectTrainerWithId(trainer: Trainer) {
        delegate?.trainerSelectedWithId(trainer: trainer)
    }
}

extension SelectTrainerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredTrainers.count
    }
    
    //TODO: Make Bindable
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.trainer.identifier, for: indexPath) as? SelectTrainer else { return UICollectionViewCell() }
        let trainerData = filteredTrainers[indexPath.row]
        if let url = trainerData.trainerAvatar {
            cell.profilePhotoImageView.sd_setImage(with: URL(string: url.persuitImageUrl()))
        }else {
            cell.profilePhotoImageView.image = UIImage(named: "profile")
        }
        cell.trainerNameLabel.text = trainerData.name
        
        return cell
    }
}

extension SelectTrainerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let trainerData = filteredTrainers[indexPath.row]
        
        userDidSelectTrainerWithId(trainer: trainerData)
    }
}

extension SelectTrainerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.selectTrainerCollectionView.bounds
        return CGSize(width: ((size.width - 20) / 3) - 1, height: size.width / 3)
    }
}

extension SelectTrainerVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredTrainers = self.trainers
        }else {
            self.filteredTrainers = self.trainers.filter{ $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
}
