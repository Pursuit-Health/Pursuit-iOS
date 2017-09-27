//
//  AssignTemplateVC.swift
//  Pursuit
//
//  Created by ігор on 9/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class AssignTemplateVC: TemplatesVC {

    //MARK: Variables
    
    var clientId: String?
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()

        loadTemplates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension AssignTemplateVC {
    override func loadTemplates() {
        Template.getAllTemplates(completion: { template, error in
            self.templatesData = template ?? []
        })
    }
}

extension AssignTemplateVC {
    func assignTemplate() {
        Client.assignTemplate(clientId: self.clientId ?? "", templateId: self.templateId ?? "") { (error) in
            if error == nil {
              self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AssignTemplateVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let templates = templatesData[indexPath.row]
        guard let id = templates.templateId else { return }
        self.templateId = "\(id)"
        assignTemplate()
    }
}

