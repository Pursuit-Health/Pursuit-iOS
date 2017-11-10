//
//  SearchExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class SearchExercisesVC: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var exercisesSearchBar: UISearchBar! {
        didSet {
            exercisesSearchBar.backgroundImage    = UIImage()
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
    
    var exercises: [String] = ["Chest", "Back", "Shoulders", "Arms", "Legs", "Abs", "Cardio"]
    
    var filteredExercises: [String] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filteredExercises = self.exercises
    }

}

extension SearchExercisesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ExercisesCell.self) else { return UITableViewCell() }
        cell.exerciseLabel.text = filteredExercises[indexPath.row]
        return cell
    }
}

extension SearchExercisesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SearchExercisesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredExercises = self.exercises
        }else {
            self.filteredExercises = self.exercises.filter{ $0.lowercased().contains(searchText.lowercased()) }
        }
    }
}
