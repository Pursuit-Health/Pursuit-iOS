//
//  ChatsListVC.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class ChatsListVC: UIViewController {
    
    //MARK: Firebase.Properties
    
    private lazy var chatRef: DatabaseReference = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!)
    private var chatRefHandle: DatabaseHandle?
    
    //MARK: Variables
    
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
    @IBOutlet weak var numberOfClientsLabel: UILabel!
    
    var chatVC: ChatVC = {
       let controller = UIStoryboard.trainer.Chat!
        return controller
    }()
    
    var chatContainerVC: ContainerChatVC = {
       let controller = UIStoryboard.trainer.ContainerChat!
        return controller
    }()
    
    var chat: ChatVC?
    
    //MARK: IBActions
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
            self.view.endEditing(true)
        }
    }
    
    var lastSeen: [String] = []
    var dialogs: [Dialog] = [] {
        didSet {
            self.filteredDialogs = dialogs
        }
    }
    
    var filteredDialogs: [Dialog] = [] {
        didSet {
            self.chatsTableView?.reloadData()
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        self.navigationController?.navigationBar.setAppearence()
        
        getDialogs()
        
        observeUnreadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = self.chat {
            self.chat = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRefHandle = nil
    }
    
    func getDialogs() {
        let queryRef = chatRef
        DispatchQueue.main.async {
             SVProgressHUD.show()
        }
      queryRef.observe(.childAdded) { (snapshot) in
         SVProgressHUD.dismiss()
            let userSnap = snapshot as! DataSnapshot
            let chatId = userSnap.key
            let userDict = userSnap.value as! [String:AnyObject]
            if let dialog = Dialog(JSON: userDict) {
                dialog.dialogId = chatId
                self.dialogs.append(dialog)
            }
            self.numberOfClientsLabel.text = self.isClientType() ? "TRAINER" : ("\(self.dialogs.count)" + " CLIENTS")
            self.chatsTableView?.reloadData()
        }
    }
    
    func observeUnreadMessages() {
        
        let unseenDialogsRef = chatRef
        unseenDialogsRef.observe(.childChanged) { (snapshot) in

            let userSnap = snapshot as! DataSnapshot
            let chatId = userSnap.key
            let userDict = userSnap.value as! [String:AnyObject]
            if let  dialog = Dialog(JSON: userDict) {
                dialog.dialogId = chatId
                for (index, dialg) in self.dialogs.enumerated() {
                    if dialg.dialogId == dialog.dialogId {
                        dialg.unseenMessages = dialog.unseenMessages
                        dialg.lastChange = dialog.lastChange
                        let indexPath = IndexPath(row: index, section: 0)
                        self.chatsTableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    fileprivate func setDateFromTimeInterval(_ timeInterval: TimeInterval?) -> String {
        guard let time = timeInterval else { return "" }
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        return dateFormatter.string(from: date)
    }
    
    private func isClientType() -> Bool {
        if let clientType = UserDefaults.standard.value(forKey: "isClient") as? Bool {
            return clientType
        }
        return false
    }
}

extension ChatsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ChatsListCell.self) else { return UITableViewCell()}
        let dialog = filteredDialogs[indexPath.row]
        cell.chatNameLabel.text = dialog.userName
        cell.timeModifiedLabel.text = setDateFromTimeInterval(dialog.lastChange)
        cell.unseenMessagesView.isHidden = !(dialog.unseenMessages ?? false)
        if let  image = dialog.userPhoto {
        cell.userPhotoImageView.sd_setImage(with: URL(string: image))
        }
        return cell
    }
}

extension ChatsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dialog = dialogs[indexPath.row]
        self.chat = UIStoryboard.trainer.Chat!
        self.chat?.dialog = dialog
        self.navigationController?.pushViewController(chat!, animated: true)
        
    }
}

extension ChatsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredDialogs = self.dialogs
        }else {
            self.filteredDialogs = self.dialogs.filter{ $0.userName?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
