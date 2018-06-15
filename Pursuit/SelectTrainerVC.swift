//
//  SelectTrainerVC.swift
//  Pursuit
//
//  Created by ігор on 9/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KeyboardWrapper

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
            
            self.selectTrainerCollectionView.ept.dataSource = self
        }
    }
    
    
    @IBOutlet weak var trainerSearchBar: UISearchBar! {
        didSet {
            trainerSearchBar.backgroundImage    = UIImage()
            trainerSearchBar.delegate = self
            trainerSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            trainerSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = trainerSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            }
            guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
            
            for view in trainerSearchBar.subviews {
                for subview in view.subviews {
                    if subview.isKind(of: UISearchBarBackground) {
                        subview.alpha = 0
                    }
                }
            }
        }
    }
    @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    
    weak var delegate: SelectTrainerVCDelegate?
    
    var keyboardWrapper = KeyboardWrapper()
    
    var trainers: [Trainer] = []
    
    var filteredTrainers: [Trainer] = [] {
        didSet {
            self.selectTrainerCollectionView.ept.reloadData()
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
        
        self.keyboardWrapper = KeyboardWrapper(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setAppearence()
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        setUpStatusBarView()
    }
    
    fileprivate func setUpStatusBarView() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            for view in window.subviews {
                if view is TopStatusBarView {
                    view.removeFromSuperview()
                }
            }
            app.setUpStatusBarAppearence()
        }
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SelectTrainerVC: KeyboardWrapperDelegate {
    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {
        
        if info.state == .willShow || info.state == .visible {
            collectionViewBottomConstraint.constant = info.endFrame.size.height
        } else {
            collectionViewBottomConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SelectTrainerVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "No Trainers"
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
