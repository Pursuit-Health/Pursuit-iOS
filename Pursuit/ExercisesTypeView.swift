//
//  ExercisesTypeView.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExercisesTypeViewDelegate: class {
    func tappedOn(_ view: ExercisesTypeView, with type: ExcersiseData.ExcersiseType)
}

class ExercisesTypeView: BBBXIBView {

    struct Constants {
        struct Cell {
            var nibName: String
            var identifier: String
            
            static let ExercisesType = Cell(nibName: "ExercisesTypeCollectionViewCell", identifier: "ExercisesTypeCollectionViewCellReuseId")
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var exercisesTypeCollectionView: UICollectionView! {
        didSet {
            let cellData    = Constants.Cell.ExercisesType
            let nib         = UINib(nibName: cellData.nibName, bundle: .main)
            
            self.exercisesTypeCollectionView.register(nib, forCellWithReuseIdentifier: cellData.identifier)
        }
    }
    
    //MARK: Variables
    
    weak var delegate: ExercisesTypeViewDelegate?
    
    var exercisesType: [ExcersiseData.ExcersiseType] = []
    var selectedType: ExcersiseData.ExcersiseType? {
        didSet {
            self.exercisesTypeCollectionView.reloadData()
        }
    }
    
     func configureCell(with types: [ExcersiseData.ExcersiseType], selectedType: ExcersiseData.ExcersiseType?) {
        self.exercisesType = types
        self.selectedType = selectedType
        if selectedType == nil {
            self.selectedType = types.first
        }
    }
    
    //MARK: Private
    
    private func handleSelection(_ cell: ExercisesTypeCollectionViewCell, for indexPath: IndexPath, isSelected: Bool) {
        
        cell.typeSelected = isSelected
        let type = self.exercisesType[indexPath.row]
        self.delegate?.tappedOn(self, with: type)
    }
    
}

extension ExercisesTypeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercisesType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.ExercisesType.identifier, for: indexPath) as? ExercisesTypeCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.typeSelected = (self.selectedType == self.exercisesType[indexPath.row])
        cell.exerciseTypeButton.setTitle(self.exercisesType[indexPath.row].name, for: .normal)
        
        return cell
    }
}

extension ExercisesTypeView: UICollectionViewDelegate {
    
}

extension ExercisesTypeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize = exercisesTypeCollectionView.frame.size
        return CGSize(width: (screenSize.width / 3), height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ExercisesTypeView: ExercisesTypeCollectionViewCellDelegate {
    func tappedOn(_ cell: ExercisesTypeCollectionViewCell) {
        guard let indexPath = exercisesTypeCollectionView.indexPath(for: cell) else { return }
        self.selectedType = self.exercisesType[indexPath.row]
    }
}
