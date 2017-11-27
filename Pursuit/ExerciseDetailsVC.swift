//
//  ExerciseDetails.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExerciseDetailsVCDelegate: class {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC)
}

class ExerciseDetailsVC: UIViewController {
    
    //MARK: Nested
    
    enum CellType {
        case exerciseType(excersize: ExcersiseData, delegate: ExercisesTypeTableViewCellDelegate)
        case name(excersize: ExcersiseData)
        case sets(excersize: ExcersiseData)
        case reps(excersize: ExcersiseData)
        case weights(excersize: ExcersiseData)
        case rest(excersize: ExcersiseData)
        case notes(excersize: ExcersiseData, delegate: NotesCellDelegate)
        
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
            case .rest:
                return AddExerciseCell.self
            case .notes:
                return NotesCell.self
            }
        }
        
        typealias TextFieldComletion = (_ text: String) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .exerciseType(let excersise, let delegate):
                if let castedCell = cell as? ExercisesTypeTableViewCell {
                    fillExerciseTypeCell(cell: castedCell, type: excersise.type, delegate: delegate)
                }
            case .name(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillNameCell(cell: castedCell, name: excersize.name, completion: { text in
                        completion(text)
                    })
                }
            case .sets(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillSetsCell(cell: castedCell, sets: excersize.sets, completion: { text in
                        completion(text)
                    })
                }
                
            case .reps(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRepsCell(cell: castedCell, reps: excersize.reps, completion: { text in
                        completion(text)
                    })
                }
            case .weights(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillWeightsCell(cell: castedCell, weight: excersize.weight, completion: { text in
                        completion(text)
                    })
                }
            case .rest(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRetsCell(cell: castedCell, rets: excersize.rest, completion: { text in
                        completion(text)
                    })
                }
            case .notes(let excersize, let delegate):
                if let castedCell = cell as? NotesCell {
                    fillNotesCell(cell: castedCell, notes: excersize.notes, delegate: delegate)
                }
            }
        }
        
        private func fillExerciseTypeCell(cell: ExercisesTypeTableViewCell, type: ExcersiseData.ExcersiseType?, delegate: ExercisesTypeTableViewCellDelegate) {
            cell.delegate = delegate
            let types: [ExcersiseData.ExcersiseType] = [.warmup, .workout, .cooldown]
            cell.excersiseTypeView.configureCell(with: types, selectedType: type)
        }
        
        private func fillNameCell(cell: AddExerciseCell, name: String?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Name")
            cell.exerciseImageView.image                    = imageFromName("ic_username")
            cell.exerciseTextField.text                     = name
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillSetsCell(cell: AddExerciseCell, sets: Int?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Sets")
            cell.exerciseImageView.image                    = imageFromName("time")
            cell.exerciseTextField.keyboardType             = .numberPad
            if let sets = sets {
                cell.exerciseTextField.text                 = String(sets)
            } else {
                cell.exerciseTextField.text                 = ""
            }
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillRepsCell(cell: AddExerciseCell, reps: Int?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Reps")
            cell.exerciseImageView.image                    = imageFromName("timeline")
            cell.exerciseTextField.keyboardType             = .numberPad
            if let reps = reps {
                cell.exerciseTextField.text                 = String(reps)
            } else {
                cell.exerciseTextField.text                 = ""
            }
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillWeightsCell(cell: AddExerciseCell, weight: Int?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Weights")
            cell.exerciseImageView.image                    = imageFromName("weight")
            cell.exerciseTextField.keyboardType             = .numberPad
            if let weight = weight {
                cell.exerciseTextField.text                 = String(weight)
            } else {
                cell.exerciseTextField.text                 = ""
            }
            
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillRetsCell(cell: AddExerciseCell, rets: Int?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Rest")
            cell.exerciseImageView.image                    = imageFromName("weight")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillNotesCell(cell: NotesCell, notes: String?, delegate: NotesCellDelegate){
            cell.nameLabel.text             = "Notes"
            cell.exerciseImageView.image    = imageFromName("weight")
            cell.delegate = delegate
            //cell.notesTextView.text = ""
        }
        
        
        private func placeHolderWithText(_ text: String) -> NSAttributedString {
            return  NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        
        private func imageFromName(_ imageName: String) -> UIImage {
            guard let image = UIImage(named: imageName) else { return UIImage() }
            return image
        }
    }
    
    //MARK: Properties
    
    var isInteractiv: Bool = true
    weak var delegate: ExerciseDetailsVCDelegate?
    var excersize: ExcersiseData = ExcersiseData()
    lazy var cellsInfo: [CellType] = [.exerciseType(excersize: self.excersize, delegate: self),
                                      .name(excersize: self.excersize),
                                      .sets(excersize: self.excersize),
                                      .reps(excersize: self.excersize),
                                      .weights(excersize: self.excersize),
                                      .rest(excersize: self.excersize),
                                      .notes(excersize: self.excersize, delegate: self)]
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var excersiseImageView: UIImageView!
    @IBOutlet weak var exerceiseTableView: UITableView! {
        didSet {
            self.exerceiseTableView.rowHeight = UITableViewAutomaticDimension
            self.exerceiseTableView.estimatedRowHeight = 100
        }
    }
    
    //MARK: IBActions
    
    @IBAction func confirmButtonPressed() {
        self.excersize.selected = true
        self.delegate?.ended(with: self.excersize, on: self)
    }
    
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
        self.loadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.leftTitle = self.excersize.name
    }
    
    private func loadImage() {
        self.excersiseImageView.sd_setImage(with: self.excersize.imageUrl) { (image, error, _, _) in
            if let image = image, error == nil {
                self.imageHeightConstraint.constant = self.excersiseImageView.bounds.size.width * image.size.height / image.size.width
            }
        }
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
        cellType.fillCell(cell: cell) { (cellText) in
            switch cellType {
            case .name:
                self.excersize.name = cellText
            case .sets:
                self.excersize.sets = Int(cellText)
            case .reps:
                self.excersize.reps = Int(cellText)
            case .weights:
                self.excersize.weight = Int(cellText)
            case .rest:
                self.excersize.rest = Int(cellText)

            default:
                return
            }
        }
        cell.isUserInteractionEnabled = self.isInteractiv
        return cell
    }
}

extension ExerciseDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 80
        } else if (indexPath.row == cellsInfo.count - 1){
            return UITableViewAutomaticDimension
        } else {
            return 50
        }
    }
}

extension ExerciseDetailsVC: ExercisesTypeTableViewCellDelegate {
    func tappedOn(_ cell: ExercisesTypeTableViewCell, with type: ExcersiseData.ExcersiseType) {
        
    }
}

extension ExerciseDetailsVC: NotesCellDelegate {
    func textViewDidEndEditingWith(_ text: String) {
        self.excersize.notes = text
    }
}

