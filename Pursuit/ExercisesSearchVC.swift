//
//  ExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExercisesSearchVCDelegate: class  {
    func didSelectExercise(exercise: ExcersiseData, on controller: ExercisesSearchVC)
    func endedWithExercises(_ exercises: [ExcersiseData], on controller: ExercisesSearchVC)
}

extension ExercisesSearchVCDelegate {
    func endedWithExercises(_ exercises: [ExcersiseData], on controller: ExercisesSearchVC) { }
}

protocol ExercisesSearchVCDatasource: class  {
    typealias GetExercisesByCategoryIdCompletion = (_ exercise: [ExcersiseData.InnerExcersise]?) -> Void
    func loadExercisesByCategoryId(on controller: ExercisesSearchVC, completion: @escaping GetExercisesByCategoryIdCompletion)
}

class ExercisesSearchVC: UIViewController {
    
    @IBOutlet weak var exercisesSearchBar: UISearchBar! {
        didSet {
            exercisesSearchBar.backgroundImage    = UIImage()
            exercisesSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = exercisesSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
            }
        }
    }
    
    @IBOutlet weak var exercisesTableView: UITableView! {
        didSet {
            self.exercisesTableView.rowHeight = UITableViewAutomaticDimension
            self.exercisesTableView.estimatedRowHeight = 100
        }
    }
    
    //MARK: Variables
    
    weak var delegate: ExercisesSearchVCDelegate?
    weak var datasource: ExercisesSearchVCDatasource?
    
    lazy var exercisesDetailsVC: ExerciseDetailsVC? = {
        guard let controller = UIStoryboard.trainer.ExerciseDetails else {  return UIViewController() as? ExerciseDetailsVC }
        
        return controller
        
    }()
    
    var shouldReload: Bool = true
    var exercise: ExcersiseData = ExcersiseData() {
        didSet {
            self.shouldReload = false
            for (index, exer) in self.filteredExercises.enumerated() {
                if exer.innerExercise?.id == self.exercise.innerExercise?.id {
                    self.filteredExercises[index] = self.exercise
                }
            }
            self.exercisesTableView?.reloadData()
        }
    }

    var exercises: [ExcersiseData] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    
    var filteredExercises: [ExcersiseData] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    
    var category: Category?
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let exercisesDone = self.filteredExercises.filter{ $0.selected == true }
        self.delegate?.endedWithExercises(exercisesDone, on: self)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        self.navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldReload {
        self.datasource?.loadExercisesByCategoryId(on: self, completion: { (innerexercises) in
//            self.excersisew = innerexercises.map { obj in
//                let ex = Excersise()
//                ex.ex = obj
//                return ex
//            }
//        }
            self.exercises = innerexercises?.map { obj in
                let exer = ExcersiseData()
                exer.innerExercise = obj
                return exer
            } ?? []
            self.filteredExercises = self.exercises ?? []
        })
        }
        
        self.navigationItem.leftTitle = self.category?.name ?? ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

}

extension ExercisesSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ExerciseCell.self) else { return UITableViewCell() }
        
        let exerc = filteredExercises[indexPath.row]
        cell.delegate  = self
        cell.exerciseNameLabel.text = exerc.innerExercise?.name
        cell.selectedCell = exerc.selected ?? false
        return cell
    }
}

extension ExercisesSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let exerc = filteredExercises[indexPath.row]
        self.delegate?.didSelectExercise(exercise: exerc, on: self)
    }
}

extension ExercisesSearchVC: ExerciseCellDelegate {
    func didTappedOnImage(cell: ExerciseCell) {
//        if let index = self.exercisesTableView.indexPath(for: cell) {
//            let exerc = filteredExercises[index.row]
//
//            exerc.selected = !(exerc.selected ?? false)
//            cell.selectedCell = exerc.selected ?? false
//
//        }
    }
}

extension ExercisesSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredExercises = self.exercises
        }else {
            self.filteredExercises = self.exercises.filter{ ($0.name?.lowercased().contains(searchText.lowercased())) ?? false }
        }
    }
}
