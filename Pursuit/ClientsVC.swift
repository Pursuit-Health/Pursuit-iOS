//
//  ClientsTableView.swift
//  Pursuit
//
//  Created by danz on 5/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit
import SDWebImage

protocol ClientsVCDelegate: class {
    func didSelect(client: Client, on controller: ClientsVC)
}

class ClientsVC: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var clientsTable: UITableView!
    
    @IBOutlet weak var clientsSearchBar: UISearchBar! {
        didSet {
            clientsSearchBar.backgroundImage    = UIImage()
            clientsSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
            clientsSearchBar.setImage(UIImage(named: "white_search_icon"), for: .search, state: .normal)
            if let searchField = clientsSearchBar.value(forKey: "_searchField") as? UITextField {
                searchField.borderStyle         = .none
                searchField.backgroundColor     = .clear
                searchField.textColor           = .white
                searchField.font                = UIFont(name: "Avenir", size: 15)
            }
        }
    }

    //MARK: Variables
    
    weak var delegate: ClientsVCDelegate?
    var defaultOptions                          = SwipeTableOptions()
    var isSwipeRightEnabled                     = true
    var buttonDisplayMode: ButtonDisplayMode    = .titleAndImage
    var buttonStyle: ButtonStyle                = .backgroundColor
    
    
    lazy var assignTemplateVC: AssignTemplateVC? = {
        
        guard let controller = UIStoryboard.trainer.AssignTemplate else { return UIViewController() as? AssignTemplateVC }
        
        return controller
    }()
    
    lazy var clientScheduleVC: ScheduleClientVC? = {
        guard let controller = UIStoryboard.trainer.ScheduleClient else { return UIViewController() as? ScheduleClientVC }
        
        return controller
    }()
    
    var client: [Client] = []
    
    var filteredClients: [Client] = [] {
        didSet {
            self.clientsTable.reloadData()
        }
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
        
        navigationController?.navigationBar.setAppearence()
        
        loadClients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "SelectClients", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func loadClients(){
        Client.getAllClients(completion: { trainersInfo, error in
            if let data = trainersInfo {
                self.client             = data
                self.filteredClients    = data
            }
        })
    }
    
    //TABLEVIEW NOTIFCATIONS
    
    // MARK: - Actions
    
    @IBAction func moreTapped(_ sender: Any) {
        let controller = UIAlertController(title: "Swipe Transition Style", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Chat", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
        controller.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
        controller.addAction(UIAlertAction(title: "Performance", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
        controller.addAction(UIAlertAction(title: "Schedule", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
        
        present(controller, animated: true, completion: nil)
    }    
}

extension ClientsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredClients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.gc_dequeueReusableCell(type: ClientCell.self) else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        
        let clientData = filteredClients[indexPath.row]
        if let url = clientData.clientAvatar {
         cell.clientImage.sd_setImage(with: URL(string: url.persuitImageUrl()))            
        }else {
            cell.clientImage.image = UIImage(named: "profile")
        }
        
        cell.clientName.text = clientData.name
        
        cell.clientImage.clipsToBounds = true;
        
        //changes cell text color
        cell.clientName.textColor = UIColor.white;
        
        cell.delegate = self
        return cell
    }
}

extension ClientsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelect(client: self.filteredClients[indexPath.row], on: self)
    }
}

extension ClientsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText == "" {
            self.filteredClients = self.client
        }else {
            self.filteredClients = self.client.filter{ $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
        searchBar.resignFirstResponder()
    }
}



extension ClientsVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation){
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation){
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        //let client = clientList[indexPath.row]
        
        if orientation == .left {
            
            //DISPLAY OPTIONS UPON LEFT SWIPE
            let chat = SwipeAction(style: .default, title: nil){ action, indexPath in
                print("chat pressed")
                //action for chat press
            }
            chat.hidesWhenSelected = true
            chat.image = #imageLiteral(resourceName: "btnChat")
            chat.backgroundColor = UIColor(red: (101/255.0), green: (99/255.0), blue: (164/255.0), alpha: 1.0)
            //configure(action: chat, with: .chat)
            
            
            let share = SwipeAction(style: .default, title: nil){ action, indexPath in
                print("share pressed")
                
                guard let controller = self.assignTemplateVC else  { return }
                
                if let clientId = self.filteredClients[indexPath.row].id {
                    controller.clientId = "\(clientId)"
                }
                //if let clientId == clients[indexPath.row]
                
                self.navigationController?.pushViewController(controller, animated: true)
                
                //action for share press
            }
            share.hidesWhenSelected = true
            share.image = #imageLiteral(resourceName: "btnShare")
            share.backgroundColor = UIColor(red: (80/255.0), green: (210/255.0), blue: (194/255.0), alpha: 1.0)
            //configure(action: share, with: .share)
            
            
            let performance = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("performance pressed")
                //action for preformance press
            }
            performance.hidesWhenSelected = true
            performance.image = #imageLiteral(resourceName: "btnPerformance")
            performance.backgroundColor = UIColor(red: (140/255.0), green: (136/255.0), blue: (255/255.0), alpha: 1.0)
            //configure(action: performance, with: .performance)
            
            
            let schedule = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("schedule pressed")
                //action for schedule press
                
                guard let controller = self.clientScheduleVC else { return }
                self.filteredClients[indexPath.row].isSelected = true
                controller.clients = [self.filteredClients[indexPath.row]]
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
            schedule.hidesWhenSelected = true
            schedule.image = #imageLiteral(resourceName: "btnSchedule")
            schedule.backgroundColor = UIColor(red: (252/255.0), green: (55/255.0), blue: (104/255.0), alpha: 1.0)
            //configure(action: schedule, with: .schedule) //??
            
            //let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            
            return [chat, share, performance, schedule]
            
        }else{
            //nothing happens if swipe is left
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.transitionStyle = .border //or drag/reveal/border
        options.expansionStyle = .none
        options.buttonPadding = 0
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
        
    }
}


class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

enum ActionDescriptor {
    case chat, share, performance, schedule
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .chat: return "Chat"
        case .share: return "Share"
        case .performance: return "Performance"
        case .schedule: return "Schedule"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .chat: name = "Chat"
        case .share: name = "Share"
        case .performance: name = "Performance"
        case .schedule: name = "Schedule"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .chat: return UIColor(red: (101/255.0), green: (99/255.0), blue: (164/255.0), alpha: 1.0)
        case .share: return UIColor(red: (80/255.0), green: (210/255.0), blue: (194/255.0), alpha: 1.0)
        case .performance: return UIColor(red: (140/255.0), green: (136/255.0), blue: (255/255.0), alpha: 1.0)
        case .schedule: return UIColor(red: (252/255.0), green: (55/255.0), blue: (104/255.0), alpha: 1.0)
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}




