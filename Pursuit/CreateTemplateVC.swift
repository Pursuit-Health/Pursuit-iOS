//
//  CreateTemplateVC.swift
//  Pursuit
//
//  Created by ігор on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol CreateTemplateVCDelegate: class {
    func saveTemplate(_ template: Template, on controllers: CreateTemplateVC)
}

class CreateTemplateVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var templateTableView: UITableView! {
        didSet {
            templateTableView.rowHeight             = UITableViewAutomaticDimension
            templateTableView.estimatedRowHeight    = 200
        }
    }
    
    @IBOutlet weak var templateNameTextField: UITextField! {
        didSet {
            self.templateNameTextField.attributedPlaceholder =  NSAttributedString(string: "Template Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
            if self.templateId == nil {
                self.templateNameTextField.text = ""
            }
        }
    }
    
    //MARK: Variables
    
    weak var delegate: CreateTemplateVCDelegate?
    
    var templateId: String? {
        didSet {
                loadTemplate()
        }
    }
    
    var template: Template? {
        didSet {
            guard let name = self.template?.name else { return }
            self.templateNameTextField.text = name
        }
    }
    
    var exercises: [Template.Exercises] = [] {
        didSet {
            self.templateTableView?.reloadData()
        }
    }
    
    lazy var addExercisesVC: AddExerceiseVC? = {
        let storyboard = UIStoryboard(name: Storyboards.Trainer, bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: Controllers.Identifiers.AddExercises)as? UINavigationController)?.visibleViewController as? AddExerceiseVC
        controller?.delegate = self
        
        return controller
    }()
    
    //MARK: IBActions
    
    @IBAction func addExercisesButtonPressed(_ sender: Any) {
        
        guard let controller = addExercisesVC else { return }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTemplateButtonPressed(_ sender: Any) {
        if templateNameTextField.text == "" {
           showAlert()
        }
        let template = Template()
        
        template.name = self.templateNameTextField.text
        template.imageId = 1
        template.time = 60
        template.exercisesForUpload = exercises
        if let exercises = template.exercisesForUpload {
        for index in 0...exercises.count - 1 {
            template.exercisesForUpload?[index].exerciseId = nil
        }
        }
        delegate?.saveTemplate(template, on: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    //MARK: Private
    
    private func showAlert() {
        let alert = UIAlertController(title: "Please enter Template name.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        return
    }
}

extension CreateTemplateVC {
    func loadTemplate() {
        if templateId != nil {
        loadTemplateById{ error in
            if error == nil {
                
            }else {
            }
        }
        }else {
            self.template = nil
            self.exercises = []
        }
    }
    
    private func loadTemplateById(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        Template.getTemplateWithExercises(templateId: templateId ?? "", completion: { template, error in
            if let templateInfo = template {
                self.template = templateInfo
                if let exercise  = templateInfo.exercises {
                    self.exercises = exercise
                }
            }
            completion(error)
        })
    }
}

extension CreateTemplateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TrainingTableViewCell.self) else { return UITableViewCell()
        }
        let exersiceInfo = self.exercises[indexPath.row]
        
        cell.exercisesNameLabel.text    = exersiceInfo.name
        cell.weightLabel.text           = "\(exersiceInfo.weight ?? 0)"
        cell.setsLabel.text             = "\(exersiceInfo.times ?? 0)" + "x" + "\(exersiceInfo.count ?? 0)"
        
        return cell
    }
}

extension CreateTemplateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CreateTemplateVC: AddExerceiseVCDelegate {
    func saveExercises(_ exercise: Template.Exercises, on controller: AddExerceiseVC) {
        let exercise = self.exercises + [exercise]
        self.exercises = exercise
        
    }
}
