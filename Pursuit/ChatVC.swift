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

class ChatVC: UIViewController {
    
    lazy var cellsInfo: [CellType] = [.frontSenderWithImage(message: "Looooooooooooosfmismdfksdmfksdmfksdmfksmdfksmdfksdfmskdfmskdfmksdf"), .frontSender(message: "Looooooooooooosfmismdfksdmfksdmfksdmfksmdfksmdfksdfmskdfmskdfmksdf"), .sender(message: "My message"), .frontSender(message: "Looooooooooooosfmismd")]
    
    enum CellType {
        case frontSender(message: String)
        case frontSenderWithImage(message: String)
        case sender(message: String)
        case senderWithImage(message: String)
        
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
            }
        }
        
        private func fillFrontSernderCell(cell: FrontSenderMessageCell, message: String) {
            cell.messageLabel.text = message
        }
        
        private func fillFrontSernderWithImageCell(cell: FrontSenderMessageWithImageCell, message: String) {
            cell.messageLabe.text = message
        }
        
        private func fillSenderCell(cell: SenderMessageCell, message: String) {
            cell.messageLabel.text = message
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
            messageTextView.minHeight = 20.0
            messageTextView.maxHeight = 100.0
            messageTextView.backgroundColor = .clear
            
        }
    }
    @IBOutlet weak var messagesTableView: UITableView! {
        didSet {
            self.messagesTableView.estimatedRowHeight = 100
            self.messagesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    let messages = ["Looooooooooooosfmismdfksdmfksdmfksdmfksmdfksmdfksdfmskdfmskdfmksdf", "skfsfsofkoskfosdkfosdkfoskfdoskfosdkfos", "skdfsfsdfsfjiuhgeuirgsdifisdjfisjf", "skfsidfsifisdjisdfjisfjsidf", "skdfksdmskdfms", "kdmsdmsdfijsd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setUpBackgroundImage()
    }
    
    //MARK: IBActions
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
