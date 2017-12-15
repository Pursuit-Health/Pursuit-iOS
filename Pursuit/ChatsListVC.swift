//
//  ChatsListVC.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

class ChatsListVC: UIViewController {
    
    @IBOutlet weak var chatSearchBar: UISearchBar! {
        didSet {
            chatSearchBar.backgroundImage    = UIImage()
            chatSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = chatSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
                searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            }
        }
    }
    
    @IBOutlet weak var chatsTableView: UITableView! {
        didSet {
            self.chatsTableView.estimatedRowHeight  = 100
            self.chatsTableView.rowHeight           = UITableViewAutomaticDimension
        }
    }
    
    var chatVC: ChatVC = {
       let controller = UIStoryboard.trainer.Chat!
        return controller
    }()
    
    var chatContainerVC: ContainerChatVC = {
       let controller = UIStoryboard.trainer.ContainerChat!
        return controller
    }()
    
    //MARK: IBActions
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
            self.view.endEditing(true)
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        self.navigationController?.navigationBar.setAppearence()
    }
    
}

extension ChatsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ChatsListCell.self) else { return UITableViewCell()}
        return cell
    }
}

extension ChatsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
}
