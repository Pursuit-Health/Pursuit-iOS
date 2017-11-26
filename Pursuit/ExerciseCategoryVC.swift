//
//  SearchExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExerciseCategoryVCDelegate: class {
    //func didSelectExercise(exercise: Template.Exercises, on controller: ExerciseCategoryVC)
    func didSelectCategory(category: Category, on controller: ExerciseCategoryVC)
}

protocol ExerciseCategoryVCDatasource: class {
    typealias GetTrainerCategories = (_ categories: [Category]?) -> Void
    func loadInfo(controller: ExerciseCategoryVC, completion: @escaping GetTrainerCategories)
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
    weak var datasource: ExerciseCategoryVCDatasource?
    
    var categories: [Category] = [] {
        didSet {
            
        }
    }
    
    var filteredCategories: [Category] = [] {
        didSet {
           self.exercisesTableView?.reloadData()
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.datasource?.loadInfo(controller: self, completion: { (categories) in
            self.categories = categories ?? []
            self.filteredCategories = categories ?? []
        })
    }

}

extension ExerciseCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ExerciseCategoryCell.self) else { return UITableViewCell() }
        cell.exerciseLabel.text = filteredCategories[indexPath.row].name
        return cell
    }
}

extension ExerciseCategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = filteredCategories[indexPath.row]
        //self.delegate?.didSelectExercise(exercise: exercise, on: self)
        self.delegate?.didSelectCategory(category: category, on: self)
    }
}

extension ExerciseCategoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredCategories = self.categories
        }else {
            self.filteredCategories = self.categories.filter{ ($0.name?.lowercased().contains(searchText.lowercased())) ?? false }
        }
    }
}
