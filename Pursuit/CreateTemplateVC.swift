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
        
        guard let controller = UIStoryboard.trainer.AddExercises else { return UIViewController() as? AddExerceiseVC }
        
        controller.delegate = self
        
        return controller
    }()
    
    lazy var mainExercisesVC: MainExercisesVC? = {
        guard let controller = UIStoryboard.trainer.MainExercises else { return UIViewController() as? MainExercisesVC }

        return controller
    }()
    
    //MARK: IBActions
    
    @IBAction func addExercisesButtonPressed(_ sender: Any) {
        
        guard let controller = mainExercisesVC else { return }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTemplateButtonPressed(_ sender: Any) {
        if templateNameTextField.text == "" {
            showAlert()
            return
        }
        let template = Template()
        
        template.name = self.templateNameTextField.text
        template.imageId = 1
        template.time = 60
        template.exercisesForUpload = exercises
        if let newExercises = template.exercisesForUpload {
            if newExercises.count > 0 {
                for index in 0...newExercises.count - 1 {
                    template.exercisesForUpload?[index].exerciseId = nil
                }
            }
        }
        delegate?.saveTemplate(template, on: self)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setAppearence()
        self.tabBarController?.tabBar.isHidden = true
        if self.templateId == nil {
            self.templateNameTextField.text = ""
        }
    }
    
    //MARK: Private
    
    private func showAlert() {
        let alert = UIAlertController(title: "Please enter Template name.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
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
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView()
        view.sectionNameLabel.text = "section".uppercased() + "\(section)"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
}

extension CreateTemplateVC: AddExerceiseVCDelegate {
    func saveExercises(_ exercise: Template.Exercises, on controller: AddExerceiseVC) {
        let exercise = self.exercises + [exercise]
        self.exercises = exercise
        
    }
}
