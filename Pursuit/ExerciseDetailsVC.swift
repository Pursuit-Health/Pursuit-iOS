//
//  ExerciseDetails.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ExerciseDetailsVC: UIViewController {

    
    //MARK: Variables
   
    
    var exerciseName: String?
    
    lazy var cellsInfo: [CellType] = [.exerciseType(delegate: self), .name, .sets, .reps, .weights]

    //MARK: Nested
    
    enum CellType {
        case exerciseType(delegate: ExercisesTypeTableViewCellDelegate)
        case name
        case sets
        case reps
        case weights
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .exerciseType:
                return ExercisesTypeTableViewCell.self
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
        func fillCell(name: String, cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .exerciseType(let delegate):
                if let castedCell = cell as? ExercisesTypeTableViewCell {
                    fillExerciseTypeCell(cell: castedCell, delegate: delegate)
                }
            case .name:
                if let castedCell = cell as? AddExerciseCell {
                    fillNameCell(cell: castedCell, name: name, completion: { text in
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
        
        private func fillExerciseTypeCell(cell: ExercisesTypeTableViewCell, delegate: ExercisesTypeTableViewCellDelegate) {
            cell.delegate = delegate
            let types: [ExerciseType] = [.warmup, .workout, .cooldown]
            cell.configureCell(with: types)
        }
        
        private func fillNameCell(cell: AddExerciseCell, name: String, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Name")
            cell.exerciseImageView.image                    = imageFromName("ic_username")
            cell.exerciseTextField.text = name
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
            return  NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        
        private func imageFromName(_ imageName: String) -> UIImage {
            guard let image = UIImage(named: imageName) else { return UIImage() }
            return image
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var exerceiseTableView: UITableView! {
        didSet {
            self.exerceiseTableView.rowHeight = UITableViewAutomaticDimension
            //self.exerceiseTableView.estimatedRowHeight = 50
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        popViewController()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.setAppearence()
        
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftTitle = self.exerciseName ?? ""
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ExerciseDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellsInfo[indexPath.row]
        
        guard let cell = tableView.gc_dequeueReusableCell(type: cellType.cellType) else { return UITableViewCell() }
        cellType.fillCell(name: exerciseName ?? "", cell: cell) { (cellText) in
//            switch cellType {
//            case .name:
//
//            case .sets:
//
//            case .reps:
//
//            case .weights:
//
//            case .exerciseType(let delegate):
//
//            }
        }
        return cell
    }
}

extension ExerciseDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 80
        } else {
            return 50
        }
    }
}


extension ExerciseDetailsVC: ExercisesTypeTableViewCellDelegate {
    func tappedOn(_ cell: ExercisesTypeTableViewCell, with type: ExerciseType) {
        
    }
}

