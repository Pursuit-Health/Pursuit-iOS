//
//  TemplatesVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 6/1/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TemplatesVC: UIViewController {
    
    //MARK: Constants
    struct Constants {
        struct Segues {
            static let CreateTemplate = "ShowCreateTemplateVCSegueID"
        }
    }
    //MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 200
        }
    }
    
    //MARK: Variables
    
    var isEditTemplate: Bool = false
    
    var templatesData: [Template] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var templateId: String?
    
    lazy var createTemplateVC: CreateTemplateVC? = {
        
        guard let controller = UIStoryboard.trainer.CreateTemplate else {  return UIViewController() as? CreateTemplateVC }
        
        controller.delegate = self
        
        return controller
    }()
    
    //MARK: IBActions
    
    @IBAction func createTemplateButtonPressed(_ sender: Any) {
        self.isEditTemplate = false
        guard let controller = createTemplateVC else { return }
    
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setAppearence()
        loadTemplates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false

    }

    //MARK: Private
    
    fileprivate func pushCreateTemplateVC() {
        guard let controller = createTemplateVC else { return }
    
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func createTemplate(_ template: Template) {
        Template.createTemplate(templateData: template) { (template, error) in
            
            if let error = error {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.present(error.alert(action: action), animated: true, completion: nil)
            }else {
                guard let controller = self.self.createTemplateVC else { return }
                controller.navigationController?.popViewController(animated: true)
                self.loadTemplates()
            }
        }
    }
    
    fileprivate func editTemplate(_ template: Template) {
        Template.editTemplate(templateId: self.templateId ?? "", templateData: template) { (template, error) in
            if error == nil {
                self.loadTemplates()
            }
        }
    }
}

//TODO: why it's repeating
extension TemplatesVC {
    func loadTemplates() {
        Template.getAllTemplates(completion: { template, error in
            self.templatesData = template ?? []
        })
    }
}

extension TemplatesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templatesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TemplateCell.self) else { return UITableViewCell() }
        let templates = templatesData[indexPath.row]
        cell.templateNameLabel.text = templates.name
        cell.templateTimeLabel.text = "\(templates.time ?? 0)" + " minutes"
        return cell
    }
}

extension TemplatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let templates = templatesData[indexPath.row]
        guard let id = templates.templateId else { return }
        self.templateId = "\(id)"
        self.isEditTemplate = true
        pushCreateTemplateVC()
    }
}

extension TemplatesVC: CreateTemplateVCDelegate {
    func saveWorkout(_ workout: Workout, on controller: CreateTemplateVC) {
    
    }
    
    func saveTemplate(_ template: Template, on controllers: CreateTemplateVC) {
        if isEditTemplate {
            editTemplate(template)
        }else {
            createTemplate(template)
        }
    }
}


