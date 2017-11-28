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
    func customexerciseAdded(exercise: ExcersiseData, on controller: AddExerceiseVC)
}

class AddExerceiseVC: UIViewController {
    
    //MARK: Nested
    
    enum CellType {
        case name
        case sets
        case reps
        case weights
        case rest
        case notes(delegate: NotesCellDelegate)
        
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
            case .rest:
                return AddExerciseCell.self
            case .notes:
                return NotesCell.self
                
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
            case .rest:
                if let castedCell = cell as? AddExerciseCell {
                    fillRetsCell(cell: castedCell, completion: { text in
                        completion(text)
                    })
                }
            case .notes(let delegate):
                if let castedCell = cell as? NotesCell {
                    fillNotesCell(cell: castedCell, delegate: delegate)
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
        
        private func fillRetsCell(cell: AddExerciseCell, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Rest")
            cell.exerciseImageView.image                    = imageFromName("weight")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillNotesCell(cell: NotesCell, delegate: NotesCellDelegate) {
            cell.nameLabel.text             = "Notes"
            cell.exerciseImageView.image    = imageFromName("weight")
            cell.delegate = delegate
//            cell.exerciseTextField.keyboardType             = .default
//            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
//                if let text = textField?.text {
//                    completion(text)
//                }
//            }
        }
        
        private func placeHolderWithText(_ text: String) -> NSAttributedString {
            return  NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        
        private func imageFromName(_ imageName: String) -> UIImage {
            guard let image = UIImage(named: imageName) else { return UIImage() }
            return image
        }
    }
    
    
    //MARK: Variables
    
    var exercise = ExcersiseData()
    
    weak var delegate: AddExerceiseVCDelegate?
    
    lazy var cellsInfo: [CellType] = [.name, .sets, .reps, .weights, .rest, .notes(delegate: self)]
    
    var exerciseType: ExcersiseData.ExcersiseType?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var exerciseTypeView: UIView! {
        didSet {
            let types: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
            let view = ExercisesTypeView()
            view.configureCell(with: types, selectedType: .warmup)
            view.delegate = self
            self.exerciseTypeView.addSubview(view)
            self.exerciseTypeView.addConstraints(UIView.place(view, onOtherView: self.exerciseTypeView))
        }
    }
    @IBOutlet weak var exerceiseTableView: UITableView! {
        didSet {
            self.exerceiseTableView.rowHeight = UITableViewAutomaticDimension
            self.exerceiseTableView.estimatedRowHeight = 50
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.exercise.type = self.exerciseType
        delegate?.customexerciseAdded(exercise: self.exercise, on: self)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        popViewController()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.exerciseType = .warmup
        self.exercise.type = self.exerciseType
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
                self.exercise.sets = Int(cellText)
            case .reps:
                self.exercise.reps = Int(cellText)
            case .weights:
                self.exercise.weight = Int(cellText)
            case .rest:
                self.exercise.rest = Int(cellText)
            case .notes:
                break
            }
        }
        return cell
    }
}

extension AddExerceiseVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row >= cellsInfo.count - 1){
            return UITableViewAutomaticDimension
        } else {
            return 50
        }
    }
}

extension AddExerceiseVC: ExercisesTypeViewDelegate {
    func tappedOn(_ view: ExercisesTypeView, with type: ExcersiseData.ExcersiseType) {
        self.exerciseType = type
        self.exercise.type = self.exerciseType
    }
}

extension AddExerceiseVC: NotesCellDelegate {
    func textViewDidEndEditingWith(_ text: String) {
        self.exercise.notes = text
    }
}
