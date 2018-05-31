//
//  ExerciseDetails.swift
//  Pursuit
//
//  Created by Igor on 11/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol ExerciseDetailsVCDelegate: class {
    func ended(with info: ExcersiseData, on controller: ExerciseDetailsVC)
}

extension ExerciseDetailsVC.CellType: Equatable {
    static func == (lhs: ExerciseDetailsVC.CellType, rhs: ExerciseDetailsVC.CellType) -> Bool {
        switch (lhs, rhs) {
        case (.exerciseType, .exerciseType), (.name, .name), (.sets, .sets), (.reps, .reps), (.weights, .weights), (.rest, .rest), (.notes, .notes), (.description, .description), (.configureWeights, .configureWeights), (.configureReps, .configureReps), (.exerciseStateCell, .exerciseStateCell), (.weightedExerciseStateCell, .weightedExerciseStateCell), (.straightExerciseStateCell, .straightExerciseStateCell):
            return true
        default:
            return false
        }
    }
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
        case configureWeights(index: Int, excersize: ExcersiseData)
        case configureReps(index: Int, excersize: ExcersiseData)
        case exerciseStateCell()
        case weightedExerciseStateCell(delegate: WeightedExerciseStateCellDelegate, exercise: ExcersiseData)
        case straightExerciseStateCell(delegate: StraightExerciseStateCellDelegate, exercise: ExcersiseData)
        
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
                    fillNameCell(cell: castedCell, name: excersize.name, completion: {  text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .sets(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillSetsCell(cell: castedCell, sets: excersize.sets_count, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
                
            case .reps(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRepsCell(cell: castedCell, excersize: excersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .weights(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillWeightsCell(cell: castedCell, excersize: excersize, completion: { text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .rest(let excersize):
                if let castedCell = cell as? AddExerciseCell {
                    fillRetsCell(cell: castedCell, rets: excersize.rest, completion: {  text1, text2 in
                        completion(text1, text2)
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
                
            case .configureWeights(let index, let exersize):
                if let castedCell = cell as? ConfigureSetsCell {
                    fillMinMaxWeightsCell(cell: castedCell, index: index, exersize: exersize, completion: {  text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .configureReps(let index, let exersize):
                if let castedCell = cell as? ConfigureSetsCell {
                    fillMinMaxRepsCell(cell: castedCell, index: index, exersize: exersize, completion: {  text1, text2 in
                        completion(text1, text2)
                    })
                }
            case .exerciseStateCell:
                if let castedCell = cell as? ExerciseStateCell {
                    
                }
            case .straightExerciseStateCell(let delegate, let exercise):
                if let castedCell = cell as? StraightExerciseStateCell {
                    fillStraightExerciseStateCell(cell: castedCell,exercise: exercise, delegate: delegate)
                }
            case .weightedExerciseStateCell(let delegate, let exercise):
                if let castedCell = cell as? WeightedExerciseStateCell {
                    fillWeightedExerciseStateCell(cell: castedCell,exercise: exercise, delegate: delegate)
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
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
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
            if (excersize.isStraitSets ?? false) {
                cell.exerciseTextField.text = "\(excersize.sets?.first?.reps_min ?? 0)"
            }else if let rep = excersize.reps {
                cell.exerciseTextField.text                 = String(rep)
            } else {
                cell.exerciseTextField.text                 = ""
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
            if (excersize.isStraitSets ?? false) {
                let weight = Double(excersize.sets?.first?.weight_min ?? 0)
                cell.exerciseTextField.text = UserSettings.shared.weightsType.getWeightsFrom(weight: weight)
            }else if let weight = excersize.weight {
                cell.exerciseTextField.text                 = String(weight)
            } else {
                cell.exerciseTextField.text                 = ""
            }
            
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
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
            cell.exerciseTextField.bbb_changedBlock = { (textField) in
                if let text = textField.text {
                    completion(text, nil)
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
        
        private func fillMinMaxWeightsCell(cell: ConfigureSetsCell, index: Int, exersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.minTextField.attributedPlaceholder    = placeHolderWithText("Min Weight")
            cell.maxTextField.attributedPlaceholder    = placeHolderWithText("Max Weight")
            cell.maxTextField.keyboardType             = .numberPad
            cell.minTextField.keyboardType             = .numberPad
            cell.exImageView.image                     = imageFromName("weight")
            cell.headerNameLabel.text                  = ""
            cell.headerHeightConstraint.constant       = 0
            if let min = exersize.sets?[index].weight_min {
                cell.minTextField.text = "\(min)"
            }else {
                cell.minTextField.text = ""
            }
            
            if let max = exersize.sets?[index].weight_max {
               cell.maxTextField.text = "\(max)"
            }else {
                cell.maxTextField.text = ""
            }
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
        }
        
        private func fillMinMaxRepsCell(cell: ConfigureSetsCell, index: Int, exersize: ExcersiseData, completion: @escaping TextFieldComletion) {
            cell.minTextField.attributedPlaceholder    = placeHolderWithText("Min Reps")
            cell.maxTextField.attributedPlaceholder    = placeHolderWithText("Max Reps")
            cell.maxTextField.keyboardType             = .numberPad
            cell.minTextField.keyboardType             = .numberPad
            cell.exImageView.image                     = imageFromName("timeline")
            cell.headerNameLabel.text                  = "SET \(index + 1)"
            cell.headerHeightConstraint.constant       = 30
            if let min = exersize.sets?[index].reps_min {
                cell.minTextField.text = "\(min)"
            }else {
                cell.minTextField.text = ""
            }
            
            if let max = exersize.sets?[index].reps_max {
                cell.maxTextField.text = "\(max)"
            }else {
                cell.maxTextField.text = ""
            }
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
        }
        
        private func fillWeightedExerciseStateCell(cell: WeightedExerciseStateCell, exercise: ExcersiseData, delegate: WeightedExerciseStateCellDelegate) {
            cell.delegate = delegate
            cell.titleLabel.text = "Weighted exercise?"
            cell.stateSwitch?.setOn(exercise.isWeighted ?? false, animated: false)
            cell.stateSwitch?.isHidden = (User.shared.coordinator is ClientCoordinator)
        }
        
        private func fillStraightExerciseStateCell(cell: StraightExerciseStateCell,exercise: ExcersiseData, delegate: StraightExerciseStateCellDelegate) {
            cell.delegate = delegate
            cell.titleLabel.text = "Straight sets?"
            cell.stateSwitch?.setOn(exercise.isStraitSets ?? false, animated: false)
            cell.stateSwitch?.isHidden = (User.shared.coordinator is ClientCoordinator)
            //cell.stateSwitch?.setOn(!((exercise.sets_count ?? 0) == (exercise.sets?.count ?? 0)), animated: false)
        }
        
        private func placeHolderWithText(_ text: String) -> NSAttributedString {
            return  NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
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
                                      .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
                                      .sets(excersize: self.excersize),
                                      .straightExerciseStateCell(delegate: self, exercise:self.excersize),
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
            
//            if self.excersize.name?.isEmpty ?? true || self.excersize.sets == nil || self.excersize.reps == nil || self.excersize.weight == nil || self.excersize.rest == nil {
//                self.showError()
//                return
//            }
        }
        
        if excersize.sets_count == nil {
            excersize.sets = []
            exerc.sets = []
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
        
        //TODO: Need refactoring
        if self.excersize.type == nil {
            self.exerciseType = .warmup
        }else {
            self.exerciseType = self.excersize.type
        }
        
        self.leftTitle = self.excersize.name
        
        if (self.excersize.isDone ?? false) {
            self.isInteractiv = false
        }
        
        self.excersize.isWeighted = self.excersize.sets_count != nil
        self.excersize.isStraitSets = (excersize.sets_count ?? 0) == 0
        
        if (excersize.sets_count ?? 0) == 0 || excersize.sets?.count  == 0 || excersize.sets?.count == nil {
           self.excersize.isStraitSets = true
        }
        
        if excersize.sets?.first?.reps_max == nil {
            self.excersize.isStraitSets = true
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
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
        cellType.fillCell(cell: cell) { (text1, text2) in
            switch cellType {
            case .name:
                self.excersize.name = text1
            case .sets:
                if let set = Int(text1 ?? "")  {
                    self.excersize.sets_count = set
                    if !(self.excersize.isStraitSets ?? true) {
                        self.recalculateSets()
                    }
                }
            case .reps:
                self.excersize.reps = Int(text1 ?? "")
                if self.excersize.isStraitSets ?? true {
                    if self.excersize.sets?.count == 1 {
                        
                    }else {
                        self.excersize.sets?.append(SetsData())
                    }
                    let rep = Int(text1 ?? "")
                    self.excersize.sets?.first?.reps_min = nil
                    self.excersize.sets?.first?.reps_min = rep
                }
            case .weights:
                self.excersize.weight = Int(text1 ?? "")
                if self.excersize.isStraitSets ?? true {
                    if self.excersize.sets?.count == 1 {
                        
                    }else {
                        self.excersize.sets?.append(SetsData())
                    }
            
                    let weigt = Double(text1 ?? "") ?? 0
                    self.excersize.sets?.first?.weight_max = nil
                    self.excersize.sets?.first?.weight_min = UserSettings.shared.weightsType.convertToServerUnit(weight: weigt)
                }
            case .rest:
                self.excersize.rest = text1
            case .configureReps(let index, _):
                if let text1 = text1 {
                    self.excersize.sets?[index].reps_min = Int(text1)
                }
                if let text2 = text2 {
                    self.excersize.sets?[index].reps_max = Int(text2)
                }
            case .configureWeights(let index, _):
                if let text1 = text1 {
                    self.excersize.sets?[index].weight_min = Int(text1)
                }
                if let text2 = text2 {
                    self.excersize.sets?[index].weight_max = Int(text2)
                }
                
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
        return UITableViewAutomaticDimension
        //        if(indexPath.row == 0){
        //            return 80
        //        }else
//        if (indexPath.row >= cellsInfo.count - 4){
//            return UITableViewAutomaticDimension
//        } else {
//            return 50
//        }
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

extension ExerciseDetailsVC: WeightedExerciseStateCellDelegate {
    func weightStateDidChnaged(on cell: WeightedExerciseStateCell, to state: Bool) {
        self.excersize.isWeighted = state
        if state {
            weightedExerciseRecalculate()
        }else {
            unWeightedExerciseRecalculate()
        }
    }
    
    func unWeightedExerciseRecalculate() {
        self.excersize.sets_count = nil
        self.excersize.sets       = []
        cellsInfo = [.exerciseType(excersize: self.excersize, delegate: self),
        .name(excersize: self.excersize),
        .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
        .rest(excersize: self.excersize),
        .notes(excersize: self.excersize, delegate: self),
        .description(excersize: self.excersize)]
        exerceiseTableView.reloadData()
    }
    
    func weightedExerciseRecalculate() {
        if self.excersize.sets_count  == nil {
            self.excersize.sets_count = 1
        }
        let setsCount = self.excersize.sets_count ?? 1
        cellsInfo = [.exerciseType(excersize: self.excersize, delegate: self),
                     .name(excersize: self.excersize),
                     .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
                    .sets(excersize: self.excersize),
                    .straightExerciseStateCell(delegate: self, exercise: self.excersize)]
    
        for i in 0..<setsCount {
            self.excersize.sets?.append(SetsData())
            cellsInfo.append(.configureReps(index: i, excersize: self.excersize))
            cellsInfo.append(.configureWeights(index: i, excersize: self.excersize))
        }
        
        let sub :[CellType] = [.rest(excersize: self.excersize),
                                .notes(excersize: self.excersize, delegate: self),
                               .description(excersize: self.excersize)]
        cellsInfo.append(contentsOf: sub)
        exerceiseTableView.reloadData()
    }
    
    func recalculateSets() {
        self.excersize.sets = []
        let setsCount = self.excersize.sets_count ?? 1
        cellsInfo = [.exerciseType(excersize: self.excersize, delegate: self),
                     .name(excersize: self.excersize),
                     .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
                     .sets(excersize: self.excersize),
                     .straightExerciseStateCell(delegate: self, exercise: self.excersize)]
        for i in 0..<setsCount {
            self.excersize.sets?.append(SetsData())
            cellsInfo.append(.configureReps(index: i, excersize: self.excersize))
            cellsInfo.append(.configureWeights(index: i, excersize: self.excersize))
        }
        
        let sub :[CellType] = [.rest(excersize: self.excersize),
                               .notes(excersize: self.excersize, delegate: self),
                               .description(excersize: self.excersize)]
        cellsInfo.append(contentsOf: sub)
        self.exerceiseTableView?.reloadData()
    }
}

extension ExerciseDetailsVC: StraightExerciseStateCellDelegate {
    func straightStateDidChnaged(on cell: StraightExerciseStateCell, to state: Bool) {
        self.excersize.isStraitSets = state
        if state {
            straitSets()
        }else {
            unstraitSets()
        }
    }
    
    func straitSets() {
        self.excersize.sets = []
        cellsInfo = [.exerciseType(excersize: self.excersize, delegate: self),
                     .name(excersize: self.excersize),
                     .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
                     .sets(excersize: self.excersize),
                     .straightExerciseStateCell(delegate: self, exercise: self.excersize),
                     .reps(excersize: self.excersize),
                     .weights(excersize: self.excersize),
                     .rest(excersize: self.excersize),
                     .notes(excersize: self.excersize, delegate: self),
                     .description(excersize: self.excersize)]
        self.exerceiseTableView?.reloadData()
    }
    
    func unstraitSets() {
        let setsCount = self.excersize.sets_count ?? 1
        cellsInfo = [.exerciseType(excersize: self.excersize, delegate: self),
                     .name(excersize: self.excersize),
                     .weightedExerciseStateCell(delegate: self, exercise:self.excersize),
                     .sets(excersize: self.excersize),
                     .straightExerciseStateCell(delegate: self, exercise: self.excersize)]

        if !(self.excersize.isStraitSets ?? false) {

            if (self.excersize.sets?.count ?? 0) > 0 && (self.excersize.sets?.first?.reps_max) == nil {
                for i in 0..<setsCount {
                    cellsInfo.append(.configureReps(index: i, excersize: self.excersize))
                    cellsInfo.append(.configureWeights(index: i, excersize: self.excersize))
                }
            }else {
                for i in 0..<setsCount {
                    self.excersize.sets?.append(SetsData())
                    cellsInfo.append(.configureReps(index: i, excersize: self.excersize))
                    cellsInfo.append(.configureWeights(index: i, excersize: self.excersize))
                }
            }
        }
        let sub :[CellType] = [.rest(excersize: self.excersize),
                               .notes(excersize: self.excersize, delegate: self),
                               .description(excersize: self.excersize)]
        cellsInfo.append(contentsOf: sub)
        exerceiseTableView.reloadData()
    }
}

