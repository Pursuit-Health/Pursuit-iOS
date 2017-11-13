//
//  SearchExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExerciseCategoryVCDelegate: class {
    func didSelectExercise(exercise: Template.Exercises, on controller: ExerciseCategoryVC)
}

class ExerciseCategoryVC: UIViewController {

    //MARK: IBOutlets
    
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
    
    weak var delegate: ExerciseCategoryVCDelegate?
    
    var exercisesNames: [String] = ["Chest", "Back", "Shoulders", "Arms", "Legs", "Abs", "Cardio"]
    var exercises: [Template.Exercises] = []
    
    var filteredExercises: [Template.Exercises] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for exerciseName in exercisesNames {
            let exercise = Template.Exercises()
            exercise.name = exerciseName
            self.exercises.append(exercise)
        }
        
        self.filteredExercises = self.exercises
    }

}

extension ExerciseCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ExerciseCategoryCell.self) else { return UITableViewCell() }
        cell.exerciseLabel.text = filteredExercises[indexPath.row].name
        return cell
    }
}

extension ExerciseCategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = filteredExercises[indexPath.row]
        self.delegate?.didSelectExercise(exercise: exercise, on: self)
    }
}

extension ExerciseCategoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredExercises = self.exercises
        }else {
            self.filteredExercises = self.exercises.filter{ ($0.name?.lowercased().contains(searchText.lowercased())) ?? false }
        }
    }
}
