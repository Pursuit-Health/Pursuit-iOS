//
//  TrainerTemplatesVC.swift
//  Pursuit
//
//  Created by ігор on 9/26/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class TrainerTemplatesVC: TemplatesVC {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTemplates()
    }
    
    private func pushCreateTemplateVC() {
        guard let controller = createTemplateVC else { return }

        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let templates = templatesData[indexPath.row]
        guard let id = templates.templateId else { return }
        self.templateId = "\(id)"
        self.isEditTemplate = true
        pushCreateTemplateVC()
    }
}

extension TrainerTemplatesVC {
//    override func loadTemplates() {
//        Template.getAllTemplates(completion: { template, error in
//            self.templatesData = template ?? []
//        })
//    }
}
