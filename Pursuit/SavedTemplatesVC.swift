//
//  SavedTemplatesVC.swift
//  Pursuit
//
//  Created by Igor on 5/22/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwiftyTimer
import MBProgressHUD
import SwipeCellKit

protocol SavedTemplatesVCDelegate: class {
    func didSelectTemplate(_ template: SavedTemplateModel, on controller: SavedTemplatesVC)
    func addNewTemplate(on controller: SavedTemplatesVC)
    func deleteTemplate(template: SavedTemplateModel, on controller: SavedTemplatesVC)
    func closeBarButtonPressed(on controller: SavedTemplatesVC)
}

class SavedTemplatesVC: UIViewController {
    
    //MARK: Variables
    
    weak var delegate: SavedTemplatesVCDelegate?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var savedTemplatesSearchBar: UISearchBar! {
        didSet {
            savedTemplatesSearchBar.backgroundImage    = UIImage()
            savedTemplatesSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            savedTemplatesSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = savedTemplatesSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            }
        }
    }
    
    @IBOutlet weak var savedTemplatesTableView: PagingTableView! {
        didSet {
            self.savedTemplatesTableView.rowHeight          = UITableViewAutomaticDimension
            self.savedTemplatesTableView.estimatedRowHeight = 100
            self.savedTemplatesTableView.delegate           = self
            self.savedTemplatesTableView.pagingDelegate     = self
            self.savedTemplatesTableView.ept.dataSource     = self
        }
    }
    
    @IBOutlet weak var addTemplateBarButton: UIBarButtonItem! {
        didSet {
            //self.addTemplateBarButton.isEnabled = self.canAddNewTemplate
        }
    }
    
    //MARK: IBActons
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.delegate?.closeBarButtonPressed(on: self)
    }
    
    @IBAction func createNewTemplateButtonPressed(_ sender: Any) {
        self.delegate?.addNewTemplate(on: self)
    }
    
    //MARK: Variables
    
    var typingTimer: Timer?
    
    var savedTemplates: [SavedTemplateModel] = [] {
        didSet {
            self.savedTemplatesTableView.reloadData()
        }
    }
    
    var canAddNewTemplate: Bool = true {
        didSet {
            //self.addTemplateBarButton.isEnabled = self.canAddNewTemplate
        }
    }
    
    fileprivate var currentWorkoutsPage: Int = 1
    
    fileprivate var searchableTemplate: String = ""
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
        navigationItem.title = "Templates"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDataSource()
        
        configureNavigationItems()
    }
    
    func updateDataSource() {
        self.loadTemplatesBy(phraseName: "", page: 0)
    }
    
    fileprivate func loadTemplatesBy(phraseName: String, page: Int, completion: (()->())? = nil) {
        self.typingTimer?.invalidate()
        self.searchableTemplate = phraseName
        SavedTemplatesObject.getSavedTemplatesBy(namePhrase: phraseName, page: page) { (savedTamplates, error) in
            completion?()
            if let error = error {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                self.savedTemplates = []
                self.savedTemplates.append(contentsOf: savedTamplates?.savedTemplates ?? [])
                self.currentWorkoutsPage    = savedTamplates?.current_page ?? 1
            }
        }
    }
    
    func configureNavigationItems() {
        let image = UIImage(named: canAddNewTemplate ? "ic_plus" : "")
        self.addTemplateBarButton.image = image
    }
}

extension SavedTemplatesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedTemplates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: SavedTemplateCell.self) else { return UITableViewCell() }
        cell.templateNameLabel.text = self.savedTemplates[indexPath.row].name ?? ""
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SavedTemplatesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        typingTimer?.invalidate()
        typingTimer = Timer.every(0.7.seconds) { (timer: Timer) in
            self.loadTemplatesBy(phraseName: searchText, page: 0)
        }
    }
}

extension SavedTemplatesVC: PagingTableViewDelegate {
    func paginate(_ tableView: PagingTableView) {
        self.savedTemplatesTableView.isLoading = true
        SavedTemplatesObject.getSavedTemplatesBy(namePhrase: searchableTemplate, page: currentWorkoutsPage + 1) { (savedTamplates, error) in
            if let error = error {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                self.savedTemplates.append(contentsOf: savedTamplates?.savedTemplates ?? [])
                self.currentWorkoutsPage    = savedTamplates?.current_page ?? 0
            }
            self.savedTemplatesTableView.isLoading = false
        }
    }
    
    func tableView(_ tableView: PagingTableView, didSelectRowAt indexPath: IndexPath) {
        let template = self.savedTemplates[indexPath.row]
        self.delegate?.didSelectTemplate(template, on: self)
    }
}

extension SavedTemplatesVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let template = self.savedTemplates[indexPath.row]
            self.savedTemplates.remove(at: indexPath.row)
            self.delegate?.deleteTemplate(template: template, on: self)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.transitionStyle = .border //or drag/reveal/border
        options.expansionStyle = .none
        options.buttonPadding = 0
        
        return options
    }
}

extension SavedTemplatesVC: PSEmptyDatasource {
    var emptyTitle: String {
        return "You don't have any saved Templates"
    }
    
    var emptyImageName: String {
        return  ""
    }
    
    var fontSize: CGFloat {
        return 25.0
    }
    
    var titleColor: UIColor {
        return UIColor.lightGray
    }
}
