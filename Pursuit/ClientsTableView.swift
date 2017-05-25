//
//  ClientsTableView.swift
//  Pursuit
//
//  Created by danz on 5/18/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SwipeCellKit

class ClientsTableView: UITableViewController {

    //view objects
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var clientsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    
    
    //struct of individual client information
    struct clientInfo {
        var clientName = String()
        var clientImage = UIImageView()
    }
    
    //list of client information
    var clientList = [clientInfo]()
    
    //list of client search results
    var filteredClientList = [clientInfo]()
    
    //show search results boolean
    var showSearchResults = false;
    
    

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returns number in clientList
        if showSearchResults == false{
            
            return clientList.count
            
        }else{
            
            return filteredClientList.count
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ClientCell", owner: self, options: nil)?.first as! ClientCell

        if showSearchResults == false {
            
            //assigns cell image
            cell.clientImage = clientList[indexPath.row].clientImage;

            //adds cell name
            cell.clientName.text = clientList[indexPath.row].clientName;
            
        }else{
            
            //assigns cell image
            cell.clientImage = filteredClientList[indexPath.row].clientImage;
 
            //adds cell name
            cell.clientName.text = filteredClientList[indexPath.row].clientName;

        }
        
        //makes cell image circular
        //cell.clientImage.layer.cornerRadius = cell.clientImage.frame.size.width/2;
        //cell.clientImage.clipsToBounds = true;
        
        //changes cell text color
        cell.clientName.textColor = UIColor.white;
        
        return cell;
        
    }

    //TABLEVIEW NOTIFCATIONS
    
    // MARK: - Actions
    
    @IBAction func moreTapped(_ sender: Any) {
        let controller = UIAlertController(title: "Swipe Transition Style", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Border", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .border }))
        controller.addAction(UIAlertAction(title: "Drag", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .drag }))
        controller.addAction(UIAlertAction(title: "Reveal", style: .default, handler: { _ in self.defaultOptions.transitionStyle = .reveal }))
        controller.addAction(UIAlertAction(title: "\(isSwipeRightEnabled ? "Disable" : "Enable") Swipe Right", style: .default, handler: { _ in self.isSwipeRightEnabled = !self.isSwipeRightEnabled }))
        controller.addAction(UIAlertAction(title: "Button Display Mode", style: .default, handler: { _ in self.buttonDisplayModeTapped() }))
        controller.addAction(UIAlertAction(title: "Button Style", style: .default, handler: { _ in self.buttonStyleTapped() }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in self.resetData() }))
        present(controller, animated: true, completion: nil)
    }
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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


extension ClientsTableView: SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let client = clientList[indexPath.row]
        
        
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
        
        /*
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        }
         */
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        /*
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
 */
}

class MailCell: SwipeTableViewCell {
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var animator: Any?
    
    var indicatorView = IndicatorView(frame: .zero)
    
    var unread = false {
        didSet {
            indicatorView.transform = unread ? CGAffineTransform.identity : CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        }
    }
    
    override func awakeFromNib() {
        setupIndicatorView()
    }
    
    func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = tintColor
        indicatorView.backgroundColor = .clear
        contentView.addSubview(indicatorView)
        
        let size: CGFloat = 12
        indicatorView.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
    }
    
    func setUnread(_ unread: Bool, animated: Bool) {
        let closure = {
            self.unread = unread
        }
        
        if #available(iOS 10, *), animated {
            var localAnimator = self.animator as? UIViewPropertyAnimator
            localAnimator?.stopAnimation(true)
            
            localAnimator = unread ? UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) : UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1.0)
            localAnimator?.addAnimations(closure)
            localAnimator?.startAnimation()
            
            self.animator = localAnimator
        } else {
            closure()
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
    case chat, share, preformance, schedule, trash
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .chat: return "Chat"
        case .share: return "Share"
        case .preformance: return "Preformance"
        case .schedule: return "Schedule"
        case .trash: return "Trash"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .chat: name = "Chat"
        case .share: name = "Share"
        case .preformance: name = "Preformance"
        case .schedule: name = "Schedule"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .chat: return UIColor(red: (101/255.0), green: (99/255.0), blue: (164/255.0), alpha: 1.0)
        case .share: return UIColor(red: (80/255.0), green: (210/255.0), blue: (194/255.0), alpha: 1.0)
        case .preformance: return UIColor(red: (140/255.0), green: (136/255.0), blue: (255/255.0), alpha: 1.0)
        case .schedule: return UIColor(red: (252/255.0), green: (55/255.0), blue: (104/255.0), alpha: 1.0)
        case .trash: return UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 1.0)
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}




