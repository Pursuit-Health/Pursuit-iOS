//
//  NotesCell.swift
//  Pursuit
//
//  Created by ігор on 11/27/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol NotesCellDelegate: class  {
    func textViewDidEndEditingWith(_ text: String)
}
class NotesCell: UITableViewCell {
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    @IBOutlet weak var notesTextView: UITextView! {
        didSet {
            self.notesTextView.delegate = self
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: NotesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension NotesCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.textViewDidEndEditingWith(textView.text ?? "")
    }
    
    func  textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}
