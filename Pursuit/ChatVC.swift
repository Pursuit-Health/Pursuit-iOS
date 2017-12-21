//
//  ChatVC.swift
//  Pursuit
//
//  Created by ігор on 12/7/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import Firebase
import GrowingTextView
import IQKeyboardManagerSwift
import KeyboardWrapper

class ChatVC: UIViewController {
    
    var cellsInfo: [CellType] = []
    
    enum CellType {
        case frontSender(message: Message)
        case frontSenderWithImage(message: String)
        case sender(message: Message)
        case senderWithImage(message: String)
        case typing()
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .frontSender:
                return FrontSenderMessageCell.self
            case .frontSenderWithImage:
                return FrontSenderMessageWithImageCell.self
            case .sender:
                return SenderMessageCell.self
            case .senderWithImage:
                return SendeMessageWithImageCell.self
            case .typing:
                return TypingCell.self
            }
        }
        
        func fillCell(cell: UITableViewCell) {
            switch self {
            case .frontSender(let message):
                if let castedCell = cell as? FrontSenderMessageCell {
                    fillFrontSernderCell(cell: castedCell, message: message)
                }
            case .frontSenderWithImage(let message):
                if let castedCell = cell as? FrontSenderMessageWithImageCell {
                    fillFrontSernderWithImageCell(cell: castedCell, message: message)
                }
                
            case .sender(let message):
                if let castedCell = cell as? SenderMessageCell {
                    fillSenderCell(cell: castedCell, message:  message)
                }
                
            case .senderWithImage(let message):
                if let castedCell = cell as? SendeMessageWithImageCell {
                    fillSenderWithImageCell(cell: castedCell, message: message)
                }
            case .typing:
                if let castedCell = cell as? TypingCell {
                    fillTypingCell(cell: castedCell)
                }
            }
        }
        
        private func fillFrontSernderCell(cell: FrontSenderMessageCell, message: Message) {
            cell.messageLabel.text = message.text ?? "" + stringFromTimeInterval(interval: message.created ?? 0)
        }
        
        private func fillFrontSernderWithImageCell(cell: FrontSenderMessageWithImageCell, message: String) {
            cell.messageLabe.text = message
        }
        
        private func fillSenderCell(cell: SenderMessageCell, message: Message) {
            cell.messageLabel.text = message.text ?? ""
            cell.createdAtLabel.text  = stringFromTimeInterval(interval: message.created ?? 0)
        }
        
        private func fillTypingCell(cell: TypingCell) {
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            
            let dots = DotsView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
            dots.numberOfDots = 5
            dots.duration = 0.4
            dots.backgroundColor = .clear
            dots.dotsColor = .white
            dots.startAnimating()
            dots.center = cell.contentView.center
            cell.contentView.addSubview(dots)
        }
        
        func stringFromTimeInterval(interval: TimeInterval) -> String {
            let newInterval = Date().timeIntervalSince1970 - interval
            let minutes = Int(newInterval/60.0)
            return "\(minutes)" + " minutes"
        }
        
        private func fillSenderWithImageCell(cell: SendeMessageWithImageCell, message: String) {
            
        }
    }
    
    @IBOutlet weak var messageTextView: GrowingTextView! {
        didSet {
            //messageTextView.maxLength = 140
            messageTextView.trimWhiteSpaceWhenEndEditing = false
            messageTextView.placeHolder = "Your message"
            messageTextView.placeHolderColor = UIColor.lightGray
            messageTextView.textColor = .white
            messageTextView.minHeight = 20.0
            messageTextView.maxHeight = 100.0
            messageTextView.backgroundColor = .clear
        }
    }
    
    @IBOutlet  var messagesTableView: UITableView! {
        didSet {
            self.messagesTableView.estimatedRowHeight = 100
            self.messagesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet  var bottomConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    
    var keyboardWrapper = KeyboardWrapper()
    
    var dialog: Dialog?
    
    private lazy var messageRef: DatabaseReference = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!)
    private var myMessageRefHandle: DatabaseHandle?
    private var otherMessageRefHandle: DatabaseHandle?
    
    var chatRef: DatabaseReference?
    
    private lazy var userIsTypingRef: DatabaseReference = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!).child((self.dialog?.dialogId ?? "")).child("typingIndicator").child((Auth.auth().currentUser?.uid)!)
    
    private lazy var usersTypingQuery: DatabaseQuery = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!).child((self.dialog?.dialogId ?? "")).child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    private var localTyping = false
    
    
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            if !isTyping {
                userIsTypingRef.removeValue()
                return
            }
            userIsTypingRef = Database.database().reference().child("user_dialogs").child(self.dialog?.userUID ?? "").child((self.dialog?.dialogId ?? "")).child("typingIndicator").child((Auth.auth().currentUser?.uid)!)
            
            userIsTypingRef.setValue(newValue)
        }
    }
    
    var message: Message? {
        didSet {
            if message?.senderId == (Auth.auth().currentUser?.uid) {
                self.cellsInfo.append(.sender(message: message!))
            }else {
                self.cellsInfo.append(.frontSender(message: message!))
            }
            let indexPath = IndexPath(row: self.cellsInfo.count - 1, section: 0)
            self.messagesTableView?.insertRows(at: [indexPath], with: .automatic)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            //self.reloadTableView()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.createMessageWith(messageTextView.text)
    }
    
    let downloadGroup = DispatchGroup()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackgroundImage()
        
        observeMessages()
        
        observeTyping()
        
        IQKeyboardManager.sharedManager().enable = false
        
        self.keyboardWrapper = KeyboardWrapper(delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = dialog?.userName ?? ""
        self.navigationController?.navigationBar.setTitleColor(.white)
    }
    
    deinit {
        if let refHandle = myMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = otherMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    private func reloadTableView() {
        let indexPath = IndexPath(row: self.cellsInfo.count - 1, section: 0)
        self.messagesTableView?.insertRows(at: [indexPath], with: .automatic)
        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func deleteLastRow() {
        let indexPath = IndexPath(row: self.cellsInfo.count, section: 0)
        self.messagesTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: Typing Indicator
    private func observeTyping() {
        var firstentry = true
        let typindIndicatorRef = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!).child((self.dialog?.dialogId ?? "")).child("typingIndicator")
        //let typingIndicatorRef = chatRef?.child("typingIndicator")
        userIsTypingRef = typindIndicatorRef//.child((Auth.auth().currentUser?.uid)!)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = (typindIndicatorRef.queryOrderedByValue().queryEqual(toValue: true))
        
        usersTypingQuery.observe(.value) { (snapshot) in
            if firstentry {
            firstentry = false
                return
            }
            
            if snapshot.childrenCount == 1{
                self.cellsInfo.append(.typing())
                self.reloadTableView()
            }else if snapshot.childrenCount == 0 {
                if self.cellsInfo.count != 0 {
                   self.cellsInfo.removeLast()
                    self.deleteLastRow()
                }
            }
        }
    }
    
    func createMessageWith(_ text: String?) {
        guard let messsage = text else { return }
        if messsage.isEmpty {
            return
        }
        
        self.isTyping = false
        let newRef = messageRef.child(dialog?.dialogId ?? "").child("messages")
        let otherUserMessage = Database.database().reference().child("user_dialogs").child(self.dialog?.userUID ?? "").child((self.dialog?.dialogId ?? "")).child("messages")
        let otherUserRef = otherUserMessage.childByAutoId()
        let ref = newRef.childByAutoId()
        let messageItem = [
            "text" : messsage,
            "created_at": Date().timeIntervalSince1970,
            "sender_id": (Auth.auth().currentUser?.uid)!
            
            ] as [String : Any]
        
        ref.setValue(messageItem)
        otherUserRef.setValue(messageItem)
        
        let lastChange = messageRef.child(dialog?.dialogId ?? "").child("last_change")
        lastChange.setValue(Date().timeIntervalSince1970)
        
        let otherUserTime = Database.database().reference().child("user_dialogs").child((Auth.auth().currentUser?.uid)!).child((self.dialog?.dialogId ?? "")).child("last_change")
        otherUserTime.setValue(Date().timeIntervalSince1970)
        self.messageTextView.text = nil
        
        
    }
    
    func observeMessages() {
        let newRef = messageRef.child(dialog?.dialogId ?? "").child("messages")
        
        myMessageRefHandle = newRef.observe(.childAdded) { (snapshot) in
            self.downloadGroup.enter()
            let chatId = snapshot.key
            let userDict = snapshot.value as! [String : AnyObject]
            if let dialog = Message(JSON: userDict) {
                dialog.messageId = chatId
                //self.messages.append(dialog)
                self.message = dialog
            }
            self.downloadGroup.leave()
        }
        
        //        let ref = Database.database().reference().child("user_dialogs").child(dialog?.userUID ?? "").child(dialog?.dialogId ?? "").child("messages")
        //        otherMessageRefHandle = ref.observe(.childAdded) { (snapshot) in
        //            self.downloadGroup.enter()
        //            let chatId = snapshot.key
        //            let userDict = snapshot.value as! [String : AnyObject]
        //            if let dialog = Message(JSON: userDict) {
        //                dialog.messageId = chatId
        //                self.messages.append(dialog)
        //            }
        //            self.downloadGroup.leave()
        //        }
        
        //        downloadGroup.notify(queue: DispatchQueue.main) {
        //            self.firMessages = self.myMessages + self.otherUserMessages
        //            self.firMessages.sort { Int($0.created!) < Int($1.created!) }
        //            for message in self.firMessages {
        //                if message.senderId == (Auth.auth().currentUser?.uid) {
        //                    self.cellsInfo.append(.sender(message: message))
        //                }else {
        //                    self.cellsInfo.append(.frontSender(message: message))
        //                }
        //            }
        //
        //            self.messagesTableView?.reloadData()
        //
        //        }
    }
    
    //    func getMessages() {
    //        let queryRef = messageRef.queryOrdered(byChild: "user/uid")
    //            .queryEqual(toValue: Auth.auth().currentUser?.uid)
    //        queryRef.observe(.value) { (snapshot) in
    //            for snap in snapshot.children {
    //                let userSnap = snap as! DataSnapshot
    //                let uid = userSnap.key
    //                let userDict = userSnap.value as! [String:AnyObject]
    //
    //                if let message = Message(JSON: userDict) {
    //                    self.firMessages.append(message)
    //                    self.cellsInfo.append(.sender(message: message))
    //                }
    //            }
    //            self.messagesTableView.reloadData()
    //        }
    //    }
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsInfo.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellsInfo[indexPath.row]
        guard let cell = tableView.gc_dequeueReusableCell(type: cellType.cellType) else { return UITableViewCell() }
        
        cellType.fillCell(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.isTyping = textView.text != nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isTyping = false
    }
}

extension ChatVC: KeyboardWrapperDelegate {
    func keyboardWrapper(_ wrapper: KeyboardWrapper, didChangeKeyboardInfo info: KeyboardInfo) {
        
        if info.state == .willShow || info.state == .visible {
            bottomConstraint.constant = info.endFrame.size.height - 60
        } else {
            bottomConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
