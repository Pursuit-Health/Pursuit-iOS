//
//  SearchExercisesVC.swift
//  Pursuit
//
//  Created by ігор on 11/10/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol ExerciseCategoryVCDelegate: class {
    func didSelectCategory(category: Category, on controller: ExerciseCategoryVC)
    func didSelectExercise(exercise: ExcersiseData.InnerExcersise, on controller: ExerciseCategoryVC)
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
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName : UIColor.white])
            }
        }
    }
        
    @IBOutlet weak var exercisesTableView: UITableView! {
        didSet {
            self.exercisesTableView.rowHeight = UITableViewAutomaticDimension
            self.exercisesTableView.estimatedRowHeight = 100
            self.exercisesTableView.ept.dataSource = self
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
    
    var exercises: [ExcersiseData.InnerExcersise] = [] {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    
    var lastChange: TimeInterval? {
        didSet {
        
        }
    }
    
    var isExercisesSearch: Bool = false {
        didSet {
            self.exercisesTableView?.reloadData()
        }
    }
    
    var timer: Timer!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     self.loadInfo()
        
    }
    
    private func loadInfo() {
        self.datasource?.loadInfo(controller: self, completion: { (categories) in
            self.categories = categories ?? []
            self.filteredCategories = categories ?? []
        })
    }
    
    func loadExercisesWithPhrase(phrase: String) {
         self.timer.invalidate()
        ExcersiseData.searchExercise(phrase: phrase) { (exercises, error) in
            if error == nil {
                self.isExercisesSearch = true
                self.exercises = exercises!
                
                self.lastChange = nil
            }else {
                self.isExercisesSearch = false;
            }
        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(checkIfUserTyping), userInfo: nil, repeats: true)
    }
    
    func checkIfUserTyping() {
        guard let last = self.lastChange else {  self.isExercisesSearch = false; return }
        if Date().timeIntervalSince1970 - Double(last) > 4 {
            guard let searchText = exercisesSearchBar.text else { self.isExercisesSearch = false; return }
            if searchText.isEmpty { return }
            
            self.loadExercisesWithPhrase(phrase: searchText)
        }
    }
}

extension ExerciseCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isExercisesSearch ? self.exercises.count : self.filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isExercisesSearch {
            guard let cell = tableView.gc_dequeueReusableCell(type: ExerciseCell.self) else { return UITableViewCell() }
            
             let exerc = exercises[indexPath.row]
                cell.exerciseNameLabel.text = exerc.name
            
          return cell
        }
        guard let cell = tableView.gc_dequeueReusableCell(type: ExerciseCategoryCell.self) else { return UITableViewCell() }
        cell.exerciseLabel.text = filteredCategories[indexPath.row].name
        return cell
    }
}

extension ExerciseCategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isExercisesSearch {
            let exercise = self.exercises[indexPath.row]
            self.delegate?.didSelectExercise(exercise: exercise, on: self)
        }else {
            let category = filteredCategories[indexPath.row]
            self.delegate?.didSelectCategory(category: category, on: self)
        }
    }
}

extension ExerciseCategoryVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.startTimer()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
         self.lastChange = Date().timeIntervalSince1970
        if searchText == "" {
            self.filteredCategories = self.categories
        }else {
            //self.filteredCategories = self.categories.filter{ ($0.name?.lowercased().contains(searchText.lowercased())) ?? false }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        if searchText.isEmpty { self.isExercisesSearch = false; return }
        
        self.loadExercisesWithPhrase(phrase: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.view.endEditing(true)
        if searchText.isEmpty { self.isExercisesSearch = false; return }
        self.loadExercisesWithPhrase(phrase: searchText)
    }
}

extension ExerciseCategoryVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "No Exercises"
    }
    
    var emptyImageName: String {
        return "no_exercises_empty_dataSet"
    }
    
    var fontSize: CGFloat {
        return 25.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}
