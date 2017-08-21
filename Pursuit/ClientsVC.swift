//
//  ClientsTableView.swift
//  Pursuit
//
//  Created by danz on 5/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit

//TODO: WTF is this. Reimplemn 100%
class ClientsVC: UIViewController {

    //view objects
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var clientsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    //TODO: add Tabulation
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    
    
    //TODO: use optionals
    struct clientInfo {
        var clientName = String()
        var clientImage = UIImage()
    }
    
    //list of client information
    var clientList = [clientInfo]()
    var filteredClientList = [clientInfo]() //search results
    var showSearchResults = false; //show search results boolean
    

    //DEFAULT LOAD AND MEMORY FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Move to didSet
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        for index in 1...5 {
            var client = clientInfo()
            client.clientName = "Janet Rose " + String(index)
            let imgName = "avatar\(index%3+1)"
            client.clientImage = UIImage(named: imgName)!
            clientList.append(client)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setUpBackgroundImage()
        
        navigationController?.navigationBar.setAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //TODO: reimplement, lets meet together regarding old files
    func textFieldDidChange(_ textField: UITextField) {
        
        var searchString = searchField.text
        searchString = searchString?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        if searchString == "" {
            
            self.showSearchResults = false
            self.clientsTable.reloadData()
            
        }else{
        
            self.filteredClientList.removeAll()
        
            //searches through each customer
            for searchClientNum in 1...clientList.count {
                var nameString = clientList[searchClientNum-1].clientName
                print(nameString)
                if nameString.lowercased().range(of: (searchString?.lowercased())!) != nil {
                    filteredClientList.append(clientList[searchClientNum-1])
                }
            }
        
        self.showSearchResults = true
        self.clientsTable.reloadData()
            
        }
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
    
    /*
    func buttonDisplayModeTapped() {
        let controller = UIAlertController(title: "Button Display Mode", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Image + Title", style: .default, handler: { _ in self.buttonDisplayMode = .titleAndImage }))
        controller.addAction(UIAlertAction(title: "Image Only", style: .default, handler: { _ in self.buttonDisplayMode = .imageOnly }))
        controller.addAction(UIAlertAction(title: "Title Only", style: .default, handler: { _ in self.buttonDisplayMode = .titleOnly }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    func buttonStyleTapped() {
        let controller = UIAlertController(title: "Button Style", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Background Color", style: .default, handler: { _ in
            self.buttonStyle = .backgroundColor
            self.defaultOptions.transitionStyle = .border
        }))
        controller.addAction(UIAlertAction(title: "Circular", style: .default, handler: { _ in
            self.buttonStyle = .circular
            self.defaultOptions.transitionStyle = .reveal
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
        
    }

    func createSelectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }
    
    func resetData() {
        //emails = mockEmails
        //emails.forEach { $0.unread = false }
        tableView.reloadData()
    }
    
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClientsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returns number in clientList
        if showSearchResults == false{
            
            return clientList.count
            
        }else{
            
            return filteredClientList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ClientCell", owner: self, options: nil)?.first as! ClientCell
        
        if showSearchResults == false {
            
            //assigns cell image
            cell.clientImage.image = clientList[indexPath.row].clientImage;
            
            //adds cell name
            cell.clientName.text = clientList[indexPath.row].clientName;
            
            if indexPath.row == clientList.count-1 {
                cell.separatorView.isHidden = true
            }
            
        }else{
            
            //assigns cell image
            cell.clientImage.image = filteredClientList[indexPath.row].clientImage;
            
            //adds cell name
            cell.clientName.text = filteredClientList[indexPath.row].clientName;
            
            if indexPath.row == filteredClientList.count-1 {
                cell.separatorView.isHidden = true
            }
        }
        
        cell.backgroundColor = UIColor.clear
        
        //makes cell image circular
        cell.clientImage.layer.cornerRadius = cell.clientImage.frame.size.width/2;
        cell.clientImage.clipsToBounds = true;
        
        //changes cell text color
        cell.clientName.textColor = UIColor.white;
        
        cell.delegate = self
        return cell;
        
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
        
        /*
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            /*
             
            let read = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                //action for swipe
            }
            
            read.hidesWhenSelected = true
            read.accessibilityLabel = email.unread ? "Mark as Read" : "Mark as Unread"
            
            let descriptor: ActionDescriptor = email.unread ? .read : .unread
            configure(action: read, with: descriptor)
            
            return [read]*/
         
        } else {
            
            let flag = SwipeAction(style: .default, title: nil, handler: nil)
            flag.hidesWhenSelected = true
            
            configure(action: flag, with: .flag)
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                self.emails.remove(at: indexPath.row)
            }
            
            configure(action: delete, with: .trash)
            
            let cell = tableView.cellForRow(at: indexPath) as! MailCell
            let closure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            
            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(title: "Reply", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Forward", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Mark...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Notify Me...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Move Message...", style: .default, handler: closure))
                controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
                self.present(controller, animated: true, completion: nil)
            }
            
            configure(action: more, with: .more)
            
            return [delete, flag, more]
        }*/
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




