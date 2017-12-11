//
//  AddExerceiseVC.swift
//  Pursuit
//
//  Created by ігор on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SHTextFieldBlocks

protocol AddExerceiseVCDelegate: class {
    func saveExercises(_ exercise: Template.Exercises, on controller: AddExerceiseVC)
}

class AddExerceiseVC: UIViewController {
    
    //MARK: Variables
    
    var exercise = Template.Exercises()
    
    weak var delegate: AddExerceiseVCDelegate?
    
    lazy var cellsInfo: [CellType] = [.name, .sets, .reps, .weights]
    
    //MARK: Nested
    
    enum CellType {
        case name
        case sets
        case reps
        case weights
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .name:
                return AddExerciseCell.self
            case .sets:
                return AddExerciseCell.self
            case .reps:
                return AddExerciseCell.self
            case .weights:
                return AddExerciseCell.self
            }
        }
        
        typealias TextFieldComletion = (_ text: String) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .name:
                if let castedCell = cell as? AddExerciseCell {
                    fillNameCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .sets:
                if let castedCell = cell as? AddExerciseCell {
                    fillSetsCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
                
            case .reps:
                if let castedCell = cell as? AddExerciseCell {
                    fillRepsCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .weights:
                if let castedCell = cell as? AddExerciseCell {
                    fillWeightsCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            }
        }
        
        
        private func fillNameCell(cell: AddExerciseCell, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Name")
            cell.exerciseImageView.image                    = imageFromName("ic_username")
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillSetsCell(cell: AddExerciseCell, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Sets")
            cell.exerciseImageView.image                    = imageFromName("time")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillRepsCell(cell: AddExerciseCell, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Reps")
            cell.exerciseImageView.image                    = imageFromName("timeline")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillWeightsCell(cell: AddExerciseCell, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Weights")
            cell.exerciseImageView.image                    = imageFromName("weight")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func placeHolderWithText(_ text: String) -> NSAttributedString {
            return  NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        
        private func imageFromName(_ imageName: String) -> UIImage {
            guard let image = UIImage(named: imageName) else { return UIImage() }
            return image
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var exerceiseTableView: UITableView! {
        didSet {
            self.exerceiseTableView.rowHeight = 50
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        delegate?.saveExercises(self.exercise, on: self)
        popViewController()
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        popViewController()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setAppearence()
        
        setUpBackgroundImage()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddExerceiseVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellsInfo[indexPath.row]
        
        guard let cell = tableView.gc_dequeueReusableCell(type: cellType.cellType) else { return UITableViewCell() }
        cellType.fillCell(cell: cell) { (cellText) in
            switch cellType {
            case .name:
                self.exercise.name = cellText
            case .sets:
                self.exercise.times = Int(cellText)
            case .reps:
                self.exercise.count = Int(cellText)
            case .weights:
                self.exercise.weight = Int(cellText)
            }
        }
        
        self.exercise.type = "count_exercise"
        return cell
    }
}
