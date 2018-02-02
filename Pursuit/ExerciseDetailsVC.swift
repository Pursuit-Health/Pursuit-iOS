//
//  ExerciseDetails.swift
//  Pursuit
//
//  Created by ігор on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol ExerciseDetailsVCDelegate: class {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC)
}

class ExerciseDetailsVC: UIViewController {
    
    //MARK: Nested
    
    enum CellType {
        case exercisePhoto(exercize: ExcersiseData)
        case exerciseType(excersize: ExcersiseData, delegate: ExercisesTypeTableViewCellDelegate)
        case name(excersize: ExcersiseData)
        case sets(excersize: ExcersiseData)
        case reps(excersize: ExcersiseData)
        case weights(excersize: ExcersiseData)
        case rest(excersize: ExcersiseData)
        case notes(excersize: ExcersiseData, delegate: NotesCellDelegate)
        case description(excersize: ExcersiseData)
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .exercisePhoto:
                return ExercisePhotoCell.self
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
            case .description:
                return DescriptionCell.self
            }
        }
        
        typealias TextFieldComletion = (_ text: String) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .exercisePhoto(let exercize):
                if let castedCell = cell as? ExercisePhotoCell {
                    fillExercisePhotoCell(cell: castedCell, exerciseUrl: exercize.innerExercise?.imageURL)
                }
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
                
            case .description(let excersize):
                if let castedCell = cell as? DescriptionCell {
                    if let desc = excersize.innerExercise?.description {
                        fillDescriptionCell(cell: castedCell, description: desc)
                    }
                }
            }
        }
        
        private func fillExercisePhotoCell(cell: ExercisePhotoCell, exerciseUrl: URL?) {
            //cell.exercisePhotoImageView.sd_setImage(with: exerciseUrl)
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
        
        private func fillRetsCell(cell: AddExerciseCell, rets: String?, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Rest")
            cell.exerciseImageView.image                    = imageFromName("rest")
            //cell.exerciseTextField.keyboardType             = .numberPad
            if let rets = rets {
                cell.exerciseTextField.text = rets
            }else {
                cell.exerciseTextField.text = ""
            }
            cell.exerciseTextField.sh_setDidEndEditing { (textField) in
                if let text = textField?.text {
                    completion(text)
                }
            }
        }
        
        private func fillNotesCell(cell: NotesCell, notes: String?, delegate: NotesCellDelegate){
            cell.nameLabel.text             = "Notes"
            cell.exerciseImageView.image    = imageFromName("notes")
            cell.delegate = delegate
            if let note = notes {
                cell.notesTextView.text = note
            }else {
                cell.notesTextView.text = ""
            }
        }
        
        private func fillDescriptionCell(cell: DescriptionCell, description: String) {
            cell.descriptionLabel.text = description
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
    
    var excersize: ExcersiseData = ExcersiseData() {
        didSet {
            if self.excersize.innerExercise?.imageURL != nil {
                self.cellsInfo.insert(.exercisePhoto(exercize: self.excersize), at: 0)
            }
            self.exerceiseTableView?.reloadData()
        }
    }
    
    var isEditExercise: Bool = false
    var isEdittemplate: Bool = false
    
    var exerciseType: ExcersiseData.ExcersiseType?
    
    lazy var cellsInfo: [CellType] = [.exerciseType(excersize: self.excersize, delegate: self),
                                      .name(excersize: self.excersize),
                                      .sets(excersize: self.excersize),
                                      .reps(excersize: self.excersize),
                                      .weights(excersize: self.excersize),
                                      .rest(excersize: self.excersize),
                                      .notes(excersize: self.excersize, delegate: self),
                                      .description(excersize: self.excersize)]
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var excersiseImageView: UIImageView!
    @IBOutlet  var exerceiseTableView: TPKeyboardAvoidingTableView! {
        didSet {
            self.exerceiseTableView.rowHeight = UITableViewAutomaticDimension
            self.exerceiseTableView.estimatedRowHeight = 100
        }
    }
    
    //MARK: IBActions
    
    @IBAction func confirmButtonPressed() {
        
        self.excersize.type = self.exerciseType
        self.excersize.description = self.excersize.innerExercise?.description
        if self.isEdittemplate {
            self.navigationController?.popViewController(animated: true)
            return
        }
        var exerc = ExcersiseData()
        if isInteractiv {
            if self.excersize.name == nil {
                self.excersize.name = self.excersize.innerExercise?.name
            }
            self.excersize.selected = true
            if !isEditExercise {
                self.excersize.exercise_id = self.excersize.id
            }
            
            exerc = self.excersize
            exerc.id = nil
            
            if self.excersize.name?.isEmpty ?? true || self.excersize.sets == nil || self.excersize.reps == nil || self.excersize.weight == nil || self.excersize.rest == nil {
                self.showError()
                return
            }
        }
        
        if !isEditExercise {
            self.delegate?.ended(with: exerc, on: self)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.excersize.type == nil {
            self.exerciseType = .warmup
        }else {
            self.exerciseType = self.excersize.type
        }
        
        self.leftTitle = self.excersize.name
        
        if (self.excersize.isDone ?? false) {
            self.isInteractiv = false
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.loadImage()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error", message: "All fields required for filling!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadImage() {
        self.excersiseImageView.sd_setImage(with: self.excersize.innerExercise?.imageURL) { (image, error, _, _) in
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
                self.excersize.rest = cellText
                
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
        
        if self.excersize.innerExercise?.imageURL == nil {
            if(indexPath.row == 0){
                return 80
            }
        }else {
            if(indexPath.row == 0){
                return UITableViewAutomaticDimension
            }else if (indexPath.row == 1) {
                return 80
            }
        }
        
        //        if(indexPath.row == 0){
        //            return 80
        //        }else
        if (indexPath.row >= cellsInfo.count - 2){
            return UITableViewAutomaticDimension
        } else {
            return 50
        }
    }
}

extension ExerciseDetailsVC: ExercisesTypeTableViewCellDelegate {
    func tappedOn(_ cell: ExercisesTypeTableViewCell, with type: ExcersiseData.ExcersiseType) {
        self.exerciseType = type
    }
}

extension ExerciseDetailsVC: NotesCellDelegate {
    func textViewDidEndEditingWith(_ text: String) {
        self.excersize.notes = text
    }
}

