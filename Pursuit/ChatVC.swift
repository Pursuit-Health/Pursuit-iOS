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
import NSDate_TimeAgo

class ChatVC: UIViewController {
    
    var cellsInfo: [CellType] = []
    
    enum CellType {
        case frontSender(message: Message?)
        case frontSenderWithImage(message: Message?)
        case sender(message: Message?)
        case senderWithImage(message: Message?)
        case typing()
        case sameFrontMessageWithText(message: Message?)
        case sameFrontMesssageWithImage(message: Message?)
        
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
            case .sameFrontMessageWithText:
                return SameMessageTextCell.self
            case .sameFrontMesssageWithImage:
                return SameMessageImageCell.self
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
                
            case .sameFrontMessageWithText(let message):
                if let castedCell = cell as? SameMessageTextCell {
                    fillSameFrontMessageWithText(cell: castedCell, message: message)
                }
                
            case .sameFrontMesssageWithImage(let message):
                if let castedCell = cell as? SameMessageImageCell {
                    fillSameFrontMessageWithImage(cell: castedCell, message: message)
                }
            }
            
        }
        
        private func fillFrontSernderCell(cell: FrontSenderMessageCell, message: Message?) {
            cell.messageLabel.text = message?.text ?? ""
            cell.timeLabel.text = createTimeString(timeInterval: (message?.created ?? 0))
            cell.userAvatarImageView.sd_setImage(with: URL(string: message?.userPhoto ?? ""), placeholderImage: UIImage(named: "ic_username"))
        }
        
        private func fillFrontSernderWithImageCell(cell: FrontSenderMessageWithImageCell, message: Message?) {
            if message?.text == nil {
                cell.messageView.isHidden = true
                cell.talesView.isHidden = true
                cell.bgView.isHidden = true 
            }
            cell.messageLabe.text = message?.text
            if message?.isHideAvatar ?? false {
                cell.avatarImageView.image = UIImage()
            }else {
                cell.avatarImageView.sd_setImage(with: URL(string: message?.userPhoto ?? ""), placeholderImage: UIImage(named: "ic_username"))
            }
            cell.sendPhotoImageView.sd_setImage(with: URL(string: message?.photo ?? ""))
        }
        
        private func fillSenderCell(cell: SenderMessageCell, message: Message?) {
            cell.messageLabel.text = message?.text ?? ""
            cell.createdAtLabel.text  = createTimeString(timeInterval: (message?.created ?? 0))
        }
        
        private func fillSenderWithImageCell(cell: SendeMessageWithImageCell, message: Message?) {
            cell.messageLabel.text = message?.text
            if message?.isHideMessageView ?? false {
              cell.messageView.isHidden = true
            }else {
              cell.messageView.isHidden = false
            }
            cell.messagePhoto.sd_setImage(with: URL(string: message?.photo ?? ""))
            cell.timeLabel.text = createTimeString(timeInterval: (message?.created ?? 0))
        }
        
        private func fillSameFrontMessageWithImage(cell: SameMessageImageCell, message: Message?) {
            cell.messageImageView.sd_setImage(with: URL(string: message?.photo ?? ""))
        }
        
        private func fillSameFrontMessageWithText(cell: SameMessageTextCell, message: Message?) {
            cell.textMessageLabel.text = message?.text ?? ""
            cell.timeLabel.text =  createTimeString(timeInterval: (message?.created ?? 0))
        }
        
        private func fillTypingCell(cell: TypingCell) {
            for view in cell.dotsView.subviews {
                view.removeFromSuperview()
            }
            
            let dots = DotsView(frame: CGRect(x: 0, y: 0, width: 100, height: cell.dotsView.frame.size.height/2))
            dots.numberOfDots = 3
            dots.duration = 0.6
            dots.backgroundColor = .clear
            dots.dotsColor = .white
            dots.startAnimating()
            dots.center = cell.dotsView.center
            cell.dotsView.addSubview(dots)
        }
        
        private func stringFromTimeInterval(interval: TimeInterval) -> String {
            let newInterval = Date().timeIntervalSince1970 - interval
            let minutes = Int(newInterval/60.0)
            return "\(minutes)" + " minutes"
        }
        
        private func createTimeString(timeInterval: TimeInterval) -> String {
            let date = NSDate(timeIntervalSince1970: (timeInterval) / 1000)
            
            return date.timeAgo()
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
    
    @IBOutlet weak var messageImageView     : UIImageView!
    @IBOutlet  var bottomConstraint         : NSLayoutConstraint!
    @IBOutlet  var photoHeightConstraint    : NSLayoutConstraint!
    
    //MARK: Properties
    
    var keyboardWrapper = KeyboardWrapper()
    
    var dialog: Dialog?
    
    lazy var senderId: String = Auth.auth().currentUser?.uid ?? " "
    lazy var receiverId: String = self.dialog?.userUID ?? " "
    
    lazy var usersDialogsRef: DatabaseReference = Database.database().reference().child("user_dialogs")
    
    //MARK: Sender References
    
    lazy var senderDialogRef: DatabaseReference = self.usersDialogsRef.child(self.senderId).child(self.dialog?.dialogId ?? " ")
    lazy var senderMessageRef: DatabaseReference = self.senderDialogRef.child("messages")
    
    lazy var sendTypingRef: DatabaseReference = self.receiverDialogRef.child("typingIndicator").child(self.senderId)
    lazy var receiveTypingRef: DatabaseReference = self.senderDialogRef.child("typingIndicator")
    
    //MARK: Receiver References
    
    lazy var receiverDialogRef: DatabaseReference = self.usersDialogsRef.child(self.receiverId).child((self.dialog?.dialogId ?? " "))
    lazy var receiverMessageRef: DatabaseReference = self.receiverDialogRef.child("messages")
    
    var chatRef: DatabaseHandle?
    
    var myMessageRefHandle: DatabaseReference?
    
    private var localTyping = false
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            if !isTyping {
                sendTypingRef.removeValue()
                return
            }
            sendTypingRef.setValue(newValue)
        }
    }
    
    var lastMessage: Message?
    
    var message: Message? {
        didSet {
            
            if message?.senderId == (self.senderId) {
                if message?.photo != nil {
                    if message?.text == nil {
                        message?.isHideMessageView = true
                    }
                    self.cellsInfo.append(.senderWithImage(message: self.message))
                }else {
                    self.cellsInfo.append(.sender(message: message!))
                }
            }else {
                if lastMessage != nil {

                    if lastMessage?.senderId == self.dialog?.userUID {
                        if self.message?.photo != nil && self.message?.text != nil {
                            self.message?.isHideAvatar = true
                            self.cellsInfo.append(.frontSenderWithImage(message: self.message))
                        }else if self.message?.photo != nil {
                            self.cellsInfo.append(.sameFrontMesssageWithImage(message: self.message))
                        }else if self.message?.text != nil {
                            self.cellsInfo.append(.sameFrontMessageWithText(message: self.message))
                        }
                    }else {
                        if self.message?.photo != nil {
                            self.cellsInfo.append(.frontSenderWithImage(message: self.message))
                        }else {
                            self.cellsInfo.append(.frontSender(message: self.message))
                        }
                    }
                }else {
                
                    if self.message?.photo != nil {
                        self.cellsInfo.append(.frontSenderWithImage(message: self.message))
                    }else {
                        self.cellsInfo.append(.frontSender(message: self.message))
                    }
                }
                
            }
            
            self.lastMessage = message
            let indexPath = IndexPath(row: self.cellsInfo.count - 1, section: 0)
            self.messagesTableView?.insertRows(at: [indexPath], with: .automatic)
            self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    var progressView = ProgressView()
    
    //MARK: IBActions
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let image = messageImageView.image {
            self.createMesageWith(self.messageTextView.text, and: image)
        }else {
            self.sendMessageWith(self.messageTextView.text, photoURL: nil)
        }
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
        
        let unsenReference = self.senderDialogRef.child("unseen")
        unsenReference.setValue(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let unsenReference = self.senderDialogRef.child("unseen")
        unsenReference.setValue(false)
    }

    private func reloadTableView() {
        let indexPath = IndexPath(row: self.cellsInfo.count - 1, section: 0)
        self.messagesTableView?.insertRows(at: [indexPath], with: .automatic)
        self.scrollToRowAt(at: indexPath)
        //self.messagesTableView.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
    }
    
    private func deleteLastRow() {
        let indexPath = IndexPath(row: self.cellsInfo.count, section: 0)
        self.messagesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func scrollToRowAt(at indexPath: IndexPath){
        self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    //MARK: Typing Indicator
    private func observeTyping() {
        var firstentry = true
        receiveTypingRef.onDisconnectRemoveValue()
        let usersTypingQuery = (receiveTypingRef.queryOrderedByValue().queryEqual(toValue: true))
        
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
    
    func createMesageWith(_ text: String?, and image: UIImage) {
        self.progressView.show(on: self.view)
        
        uploadImage(image, progressBlock: { (progress) in
            
        }, completionBlock: { (url, urlString) in
            //send message
            
            guard let photoUrl = url?.absoluteString else { return }
            
            if let mesText = text{
                self.sendMessageWith(mesText, photoURL: photoUrl)
            }else {
              self.sendMessageWith(photoURL: photoUrl)
            }
            
            self.messageImageView.image = nil
            self.photoHeightConstraint.constant = 0
            self.progressView.dissmiss(form: self.view)
        })
    }
    
    //TODO: Reimplement using one function
    
    func sendMessageWith(_ text: String?, photoURL: String?) {
        guard let messsage = text else { return }
        if messsage.isEmpty && photoURL == nil || messsage.trimmingCharacters(in: .whitespaces).isEmpty{
            return
        }
        
        var photoKey = String()
        var photoUrl = String()
        
        self.isTyping = false
        
        let otherUserRef = receiverMessageRef.childByAutoId()
        let ref = self.senderMessageRef.childByAutoId()
        var messageItem = [
            "text" : messsage.condensedWhitespace,
            "created_at": Date().timeIntervalSince1970 * 1000,
            "sender_id": self.senderId
            
            ] as [String : Any]
        if let url = photoURL {
            photoKey = "photo"
            photoUrl = url
            messageItem[photoKey] = photoUrl
        }
        
        ref.setValue(messageItem)
        otherUserRef.setValue(messageItem)
        
        let senderlastChange = self.senderDialogRef.child ("last_change")
        senderlastChange.setValue(Date().timeIntervalSince1970 * 1000)
        
        let receiverLastChange = receiverDialogRef.child("last_change")
        
        let receiverUnseenMessages = receiverDialogRef.child("unseen")
        receiverUnseenMessages.setValue(true)
        
        receiverLastChange.setValue(Date().timeIntervalSince1970 * 1000)
        self.messageTextView.text = nil
    }
    
    func sendMessageWith(photoURL: String) {

        var photoKey = String()
        var photoUrl = String()
        
        self.isTyping = false
        
        let otherUserRef = receiverMessageRef.childByAutoId()
        let ref = self.senderMessageRef.childByAutoId()
        var messageItem = [
            "created_at": Date().timeIntervalSince1970 * 1000,
            "sender_id": self.senderId
            
            ] as [String : Any]
  
            photoKey = "photo"
            photoUrl = photoURL
            messageItem[photoKey] = photoUrl
        
        
        ref.setValue(messageItem)
        otherUserRef.setValue(messageItem)
        
        let senderlastChange = self.senderDialogRef.child ("last_change")
        senderlastChange.setValue(Date().timeIntervalSince1970 * 1000)
        
        let receiverLastChange = receiverDialogRef.child("last_change")
        
        let receiverUnseenMessages = receiverDialogRef.child("unseen")
        receiverUnseenMessages.setValue(true)
        
        receiverLastChange.setValue(Date().timeIntervalSince1970 * 1000)
        self.messageTextView.text = nil
    }
    
    
    func observeMessages() {
        self.senderMessageRef.observe(.childAdded) { (snapshot) in
            self.downloadGroup.enter()
            let chatId = snapshot.key
            let userDict = snapshot.value as! [String : AnyObject]
            if let mess = Message(JSON: userDict) {
                mess.messageId = chatId
                mess.userPhoto = self.dialog?.userPhoto
                
                //self.messages.append(dialog)
                self.message = mess
            }
            self.downloadGroup.leave()
        }
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }    
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
            if self.cellsInfo.count > 0 {
            let indexPath = IndexPath(row: self.cellsInfo.count - 1, section: 0)
            self.scrollToRowAt(at: indexPath)
            }
        } else {
            bottomConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        UIView.animate(withDuration: 0.5, delay: 0, options: [] , animations: { () -> Void in
            self.photoHeightConstraint.constant = 80
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.messageImageView.image = pickedImage
        
        picker.dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}

extension ChatVC {
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child("messages/photo").child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
}
