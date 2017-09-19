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
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    
    var templatesData: [Template] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var templateId: String?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
        
        loadTemplates()
    }

    //MARK: Private
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: TemplateCell.self) else { return UITableViewCell() }
        let templates = templatesData[indexPath.row]
        cell.templateNameLabel.text = templates.name
        cell.templateTimeLabel.text = "\(templates.time ?? 0)" + "minutes"
        return cell
    }
}

extension TemplatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let templates = templatesData[indexPath.row]
        guard let id = templates.templateId else { return }
        self.templateId = "\(id)"
        
        performSegue(withIdentifier: Constants.Segues.CreateTemplate, sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController else { return }
            let controller = navController.viewControllers.first as! CreateTemplateVC
            if segue.identifier == Constants.Segues.CreateTemplate {
                controller.templateId = self.templateId
            }
    }
}
