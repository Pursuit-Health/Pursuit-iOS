//
//  ExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/13/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

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

    var exercise = Template.Exercises()
    
    var exercisesNames: [String] = ["Pushups", "Dumbbell Bench Press", "Dumbbell Flyes", "Incline Dumbbell Press", "Low Cable Crossover"]
    var exercises: [Template.Exercises] = []
    
    var filteredExercises: [Template.Exercises] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for exerciseName in exercisesNames {
            let exercise = Template.Exercises()
            exercise.name = exerciseName
            exercise.selected = false
            self.exercises.append(exercise)
        }
        
        self.filteredExercises = self.exercises
        
        setUpBackgroundImage()
        
        self.navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftTitle = self.exercise.name ?? ""
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
        cell.exerciseNameLabel.text = exerc.name
        cell.selectedCell = exerc.selected ?? false
        return cell
    }
}

extension ExercisesSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ExercisesSearchVC: ExerciseCellDelegate {
    func didTappedOnImage(cell: ExerciseCell) {
        if let index = self.exercisesTableView.indexPath(for: cell) {
            let exerc = filteredExercises[index.row]
            if let ex = exerc.selected {
            exerc.selected = !ex 
            cell.selectedCell = exerc.selected ?? false
            }
        }
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
