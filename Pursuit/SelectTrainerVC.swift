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
    
    //MARK: Variables
    
    weak var delegate: SelectTrainerVCDelegate?
    var trainerData: [User.TrainersData]? = []
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        removeController()
    }
    
    @IBAction func selectTrainer(_ sender: Any) {
        
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpBackgroundImage()
        loadTrainers()
        
        navigationController?.navigationBar.isHidden = false
    }
}

extension SelectTrainerVC {
    func loadTrainers() {
        loadTrainersRequest { error in
            if error == nil {
                self.selectTrainerCollectionView.reloadData()
            }
        }
    }
    
    private func loadTrainersRequest(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        User.getTrainers(completion: { trainersInfo, error in
            if let data = trainersInfo {
                self.trainerData = data.trainersData
            }
            completion(error)
        })
        
    }
    fileprivate func removeController() {
        
        let rootVC = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
        rootVC?.viewControllers.remove(at: 1)
    }
    fileprivate func userDidSelectTrainerWithId(_ id: Int) {
        delegate?.trainerSelectedWithId(id)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectTrainerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainerData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.trainer.identifier, for: indexPath) as? SelectTrainer else { return UICollectionViewCell() }
        
        cell.profilePhotoImageView.image = UIImage(named: "avatar1")
        cell.trainerNameLabel.text = trainerData?[indexPath.row].user?.data?.name
        return cell
    }
}

extension SelectTrainerVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userDidSelectTrainerWithId(indexPath.row)
        removeController()
    }
}

extension SelectTrainerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: ((size.width-20)/3)-1, height: size.width/3)
    }
}
