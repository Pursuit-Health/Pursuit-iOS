//
//  AddExerceiseVC.swift
//  Pursuit
//
//  Created by ігор on 9/21/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SHTextFieldBlocks
import IQKeyboardManagerSwift

protocol AddExerceiseVCDelegate: class {
    func customexerciseAdded(exercise: ExcersiseData, on controller: AddExerceiseVC)
}

extension AddExerceiseVC.CellType: Equatable {
    static func == (lhs: AddExerceiseVC.CellType, rhs: AddExerceiseVC.CellType) -> Bool {
        switch (lhs, rhs) {
        case (.name, .name), (.sets, .sets), (.reps, .reps), (.weights, .weights), (.rest, .rest), (.notes, .notes), (.configureWeights, .configureWeights), (.configureReps, .configureReps), (.exerciseStateCell, .exerciseStateCell), (.weightedExerciseStateCell, .weightedExerciseStateCell), (.straightExerciseStateCell, .straightExerciseStateCell):
            return true
        default:
            return false
        }
    }
}

class AddExerceiseVC: UIViewController {
    
    //MARK: Nested
    
    enum CellType {
        case name(excersize: ExcersiseData)
        case sets(excersize: ExcersiseData)
        case reps(excersize: ExcersiseData)
        case weights(excersize: ExcersiseData)
        case rest(excersize: ExcersiseData)
        case notes(delegate: NotesCellDelegate, excersize: ExcersiseData)
        case configureWeights(index: Int, excersize: ExcersiseData)
        case configureReps(index: Int, excersize: ExcersiseData)
        case exerciseStateCell()
        case weightedExerciseStateCell(delegate: WeightedExerciseStateCellDelegate, excersize: ExcersiseData)
        case straightExerciseStateCell(delegate: StraightExerciseStateCellDelegate, excersize: ExcersiseData)
        
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
            case .configureWeights:
                return ConfigureSetsCell.self
            case .configureReps:
                return ConfigureSetsCell.self
            case .exerciseStateCell:
                return ExerciseStateCell.self
            case .weightedExerciseStateCell:
                return WeightedExerciseStateCell.self
            case .straightExerciseStateCell:
                return StraightExerciseStateCell.self
            }
        }
        
        typealias TextFieldComletion = (_ text1: String?, _ text2: String?) -> Void
        func fillCell(cell: UITableViewCell, completion: @escaping TextFieldComletion) {
            switch self {
            case .name(let exersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillNameCell(cell: castedCell, excersize: exersize, completion: { text1, text2  in
                        completion(text1, text2)
                    })
                }
            case .sets(let exersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillSetsCell(cell: castedCell, excersize: exersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .reps(let exersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRepsCell(cell: castedCell, excersize: exersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .weights(let exersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillWeightsCell(cell: castedCell, excersize: exersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .rest(let exersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRetsCell(cell: castedCell, excersize: exersize, completion: { text1, text2  in
                        completion(text1, text2)
                    })
                }
            case .notes(let delegate, let exersize):
                if let castedCell = cell as? NotesCell {
                    fillNotesCell(cell: castedCell, excersize: exersize, delegate: delegate)
                }
            case .configureWeights(let index, let exersize):
                if let castedCell = cell as? ConfigureSetsCell {
                    fillMinMaxWeightsCell(cell: castedCell, index: index, exersize: exersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .configureReps(let index, let exersize):
                if let castedCell = cell as? ConfigureSetsCell {
                    fillMinMaxRepsCell(cell: castedCell, index: index, exersize: exersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .exerciseStateCell:
                if let castedCell = cell as? ExerciseStateCell {
                    
                }
            case .straightExerciseStateCell(let delegate, let exersize):
                if let castedCell = cell as? StraightExerciseStateCell {
                    fillStraightExerciseStateCell(cell: castedCell, exersize: exersize, delegate: delegate)
                }
            case .weightedExerciseStateCell(let delegate, let exercise):
                if let castedCell = cell as? WeightedExerciseStateCell {
                    fillWeightedExerciseStateCell(cell: castedCell, exersize: exercise, delegate: delegate)
                }
            }
        }
        
        
        private func fillNameCell(cell: AddExerciseCell, excersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Name")
            cell.exerciseImageView.image                    = imageFromName("ic_username")
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text,nil)
                }
            }
        }
        
        private func fillSetsCell(cell: AddExerciseCell, excersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Sets")
            cell.exerciseImageView.image                    = imageFromName("time")
            cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.text                     = "\(excersize.sets_count ?? 1)"
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
        }
        
        private func fillRepsCell(cell: AddExerciseCell, excersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Reps")
            cell.exerciseImageView.image                    = imageFromName("timeline")
            cell.exerciseTextField.keyboardType             = .numberPad
            if excersize.sets?.count == 1 {
               cell.exerciseTextField.text = "\(excersize.sets?.first?.reps_max ?? 0)"
            }
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
        }
        
        private func fillWeightsCell(cell: AddExerciseCell, excersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Weights")
            cell.exerciseImageView.image                    = imageFromName("weight")
            cell.exerciseTextField.keyboardType             = .numberPad
            if excersize.sets?.count == 1 {
                cell.exerciseTextField.text = "\(excersize.sets?.first?.weight_max ?? 0)"
            }
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
        }
        
        private func fillRetsCell(cell: AddExerciseCell, excersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.exerciseTextField.attributedPlaceholder    = placeHolderWithText("Rest")
            cell.exerciseImageView.image                    = imageFromName("rest")
            //cell.exerciseTextField.keyboardType             = .numberPad
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
        }
        
        private func fillNotesCell(cell: NotesCell, excersize: ExcersiseData, delegate: NotesCellDelegate) {
            cell.nameLabel.text             = "Notes"
            cell.exerciseImageView.image    = imageFromName("notes")
            cell.delegate = delegate
        }
        
        private func fillMinMaxWeightsCell(cell: ConfigureSetsCell, index: Int, exersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.minTextField.attributedPlaceholder    = placeHolderWithText("Min Weight")
            cell.maxTextField.attributedPlaceholder    = placeHolderWithText("Max Weight")
            cell.minTextField.keyboardType             = .numberPad
            cell.maxTextField.keyboardType             = .numberPad
            cell.minTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
            cell.maxTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(nil, text)
                }
            }
            cell.exImageView.image                     = imageFromName("weight")
            cell.headerNameLabel.text                  = ""
            cell.headerHeightConstraint.constant       = 0
        }
        
        private func fillMinMaxRepsCell(cell: ConfigureSetsCell, index: Int, exersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.minTextField.attributedPlaceholder    = placeHolderWithText("Min Reps")
            cell.maxTextField.attributedPlaceholder    = placeHolderWithText("Max Reps")
            cell.minTextField.keyboardType             = .numberPad
            cell.maxTextField.keyboardType             = .numberPad
            cell.minTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
                }
            }
            cell.maxTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(nil, text)
                }
            }
            cell.exImageView.image                     = imageFromName("timeline")
            cell.headerNameLabel.text                  = "SET \(index + 1)"
            cell.headerHeightConstraint.constant       = 30
        }
        
        private func fillWeightedExerciseStateCell(cell: WeightedExerciseStateCell, exersize: ExcersiseData, delegate: WeightedExerciseStateCellDelegate) {
            cell.delegate = delegate
            cell.titleLabel.text = "Weighted exercise?"
            cell.stateSwitch?.setOn(exersize.isWeighted ?? true, animated: true)
        }
        
        private func fillStraightExerciseStateCell(cell: StraightExerciseStateCell, exersize: ExcersiseData, delegate: StraightExerciseStateCellDelegate) {
            cell.delegate = delegate
            cell.titleLabel.text = "Straight sets?"
            cell.stateSwitch?.setOn(exersize.isStraitSets ?? false, animated: false)
        }
        
        private func placeHolderWithText(_ text: String) -> NSAttributedString {
            return  NSAttributedString(string: text, attributes: [NSAttributedStringKey.backgroundColor : UIColor.white])
        }
        
        private func imageFromName(_ imageName: String) -> UIImage {
            guard let image = UIImage(named: imageName) else { return UIImage() }
            return image
        }
    }
    
    
    //MARK: Variables
    
    var exercise = ExcersiseData()
    
    weak var delegate: AddExerceiseVCDelegate?
    
    lazy var cellsInfo: [CellType] = [.name(excersize: self.exercise), .weightedExerciseStateCell(delegate: self, excersize: self.exercise), .sets(excersize: self.exercise),.straightExerciseStateCell(delegate: self, excersize: self.exercise), .reps(excersize: self.exercise), .weights(excersize: self.exercise), .rest(excersize: self.exercise), .notes(delegate: self, excersize: self.exercise)]
    
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
        self.exercise.sets_count = 1
        self.exercise.sets = [SetsData()]
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
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
        cellType.fillCell(cell: cell) { (text1, text2) in
            switch cellType {
            case .name:
                self.exercise.name = text1 ?? ""
            case .sets:
                if let set = Int(text1 ?? "")  {
                        self.exercise.sets_count = set
                    if !(self.exercise.isStraitSets ?? true) {
                        self.recalculateSets()
                    }
                }
            case .reps:
                self.exercise.reps = Int(text1 ?? "")
                if self.exercise.isStraitSets ?? true {
                    if self.exercise.sets?.count == 1 {
                        
                    }else {
                        self.exercise.sets?.append(SetsData())
                    }
                    self.exercise.sets?.first?.reps_max = nil
                    self.exercise.sets?.first?.reps_min = Int(text1 ?? "")
                }

            case .weights:
                self.exercise.weight = Int(text1 ?? "")
                
                if self.exercise.isStraitSets ?? true {
                    if self.exercise.sets?.count == 1 {
                        
                    }else {
                        self.exercise.sets?.append(SetsData())
                    }
                    self.exercise.sets?.first?.weight_max = nil
                    self.exercise.sets?.first?.weight_min = Int(text1 ?? "")
                }
            case .rest:
                self.exercise.rest = text1 ?? ""
            case .configureReps(let index, _):
                if let text1 = text1 {
                    self.exercise.sets?[index].reps_min = Int(text1)
                }
                if let text2 = text2 {
                    self.exercise.sets?[index].reps_max = Int(text2)
                }
            case .configureWeights(let index, _):
                if let text1 = text1 {
                    self.exercise.sets?[index].weight_min = Int(text1)
                }
                if let text2 = text2 {
                    self.exercise.sets?[index].weight_max = Int(text2)
                }
                
            default:
                break
            }
        }
        return cell
    }
}

extension AddExerceiseVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

extension AddExerceiseVC: StraightExerciseStateCellDelegate {
    func straightStateDidChnaged(on cell: StraightExerciseStateCell, to state: Bool) {
        self.exercise.isStraitSets = state
        if state {
            straitSets()
        }else {
            unstraitSets()
        }
    }
    
    func straitSets() {
        self.exercise.sets = []
        cellsInfo = [.name(excersize: self.exercise),
                     .weightedExerciseStateCell(delegate: self, excersize: self.exercise),
                     .sets(excersize: self.exercise),
                     .straightExerciseStateCell(delegate: self, excersize: self.exercise),
                     .reps(excersize: self.exercise),
                     .weights(excersize: self.exercise),
                     .rest(excersize: self.exercise),
                     .notes(delegate: self, excersize: self.exercise)]
        self.exerceiseTableView?.reloadData()
    }
    
    func unstraitSets() {
        let setsCount = self.exercise.sets_count ?? 1
        cellsInfo = [.name(excersize: self.exercise),
                     .weightedExerciseStateCell(delegate: self, excersize:self.exercise),
                     .sets(excersize: self.exercise),
                     .straightExerciseStateCell(delegate: self, excersize: self.exercise)]
        
        if (self.exercise.sets?.count ?? 0) > 0 {
            for i in 0..<setsCount {
                cellsInfo.append(.configureReps(index: i, excersize: self.exercise))
                cellsInfo.append(.configureWeights(index: i, excersize: self.exercise))
            }
        }else {
            for i in 0..<setsCount {
                self.exercise.sets?.append(SetsData())
                cellsInfo.append(.configureReps(index: i, excersize: self.exercise))
                cellsInfo.append(.configureWeights(index: i, excersize: self.exercise))
            }
        }
        let sub :[CellType] = [.rest(excersize: self.exercise),
                               .notes(delegate: self, excersize: self.exercise)]
        cellsInfo.append(contentsOf: sub)
        exerceiseTableView.reloadData()
    }
}

extension AddExerceiseVC: WeightedExerciseStateCellDelegate {
    func weightStateDidChnaged(on cell: WeightedExerciseStateCell, to state: Bool) {
        self.exercise.isWeighted = state
        if state {
            weightedExerciseRecalculate()
        }else {
            unWeightedExerciseRecalculate()
        }
    }
    
    func unWeightedExerciseRecalculate() {
        
        self.exercise.sets_count = nil
        cellsInfo = [.name(excersize: self.exercise),
                     .weightedExerciseStateCell(delegate: self, excersize:self.exercise),
                     .rest(excersize: self.exercise),
                     .notes(delegate: self, excersize: self.exercise)]
        exerceiseTableView.reloadData()
    }
    
    func weightedExerciseRecalculate() {
        if self.exercise.sets_count  == nil {
            self.exercise.sets_count = 1
        }
        if self.exercise.sets == nil {
            self.exercise.sets = []
        }
        let setsCount = self.exercise.sets_count ?? 1
        cellsInfo = [.name(excersize: self.exercise),
                     .weightedExerciseStateCell(delegate: self, excersize:self.exercise),
                     .sets(excersize: self.exercise),
                     .straightExerciseStateCell(delegate: self, excersize: self.exercise)]
        
        for i in 0..<setsCount {
            self.exercise.sets?.append(SetsData())
            cellsInfo.append(.configureReps(index: i, excersize: self.exercise))
            cellsInfo.append(.configureWeights(index: i, excersize: self.exercise))
        }
        
        let sub :[CellType] = [.rest(excersize: self.exercise),
                               .notes(delegate: self, excersize: self.exercise)]
        cellsInfo.append(contentsOf: sub)
        exerceiseTableView.reloadData()
    }
    
    func recalculateSets() {
        self.exercise.sets = []
        let setsCount = self.exercise.sets_count ?? 0
        cellsInfo = [.name(excersize: self.exercise),
                     .weightedExerciseStateCell(delegate: self, excersize:self.exercise),
                     .sets(excersize: self.exercise),
                     .straightExerciseStateCell(delegate: self, excersize: self.exercise)]
        for i in 0..<setsCount {
            self.exercise.sets?.append(SetsData())
            cellsInfo.append(.configureReps(index: i, excersize: self.exercise))
            cellsInfo.append(.configureWeights(index: i, excersize: self.exercise))
        }
        
        let sub :[CellType] = [.rest(excersize: self.exercise),
                               .notes(delegate: self, excersize: self.exercise)]
        cellsInfo.append(contentsOf: sub)
        self.exerceiseTableView?.reloadData()
    }
}
