//
//  CreateTemplateVC.swift
//  Pursuit
//
//  Created by ігор on 8/6/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class CreateTemplateVC: UIViewController {

    //MARK: IBOutlets

    @IBOutlet weak var templateTableView: UITableView! {
        didSet {
            templateTableView.rowHeight             = UITableViewAutomaticDimension
            templateTableView.estimatedRowHeight    = 200
        }
    }
    @IBOutlet weak var templateNameLabel: UILabel!
    
    //MARK: Variables
    
    var templateId: String?
    
    var template : Template.SimpleTemplate?
    var exercises: [Template.Exercises]?
    
    //MARK: IBActions
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
        
        loadTemplate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension CreateTemplateVC {
    func loadTemplate() {
        loadTemplateById{ error in
            if error == nil {
                self.templateNameLabel.text = self.template?.name ?? ""
                self.templateTableView.reloadData()
            }
        }
    }
    
    private func loadTemplateById(completion: @escaping (_ error: ErrorProtocol?) -> Void) {
        Template.getTemplateWithExercises(templateId: templateId ?? "", completion: { template, error in
            if let templateInfo = template {
                self.template   = templateInfo.simpleTemplatedata
                self.exercises  = templateInfo.simpleTemplatedata?.exercises?.exercisesData
            }
            completion(error)
        })
    }
}

extension CreateTemplateVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.exercises?.count else { return 0 }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TrainingTableViewCell.self) else { return UITableViewCell()
        }
        let exersicesInfo = self.exercises?[indexPath.row]
        let exercissableData = exersicesInfo?.exercisable?.data
        cell.exercisesNameLabel.text = exersicesInfo?.name
        cell.weightLabel.text = "\(exercissableData?.weight ?? 0)"
        cell.setsLabel.text = "\(exercissableData?.times ?? 0)" + "x" + "\(exercissableData?.count ?? 0)"
           
            return cell
    }
}

extension CreateTemplateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
