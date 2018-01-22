//
//  SettingsVC.swift
//  Pursuit
//
//  Created by ігор on 10/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage

protocol SettingsVCDelegate: class {
    func logoutPressed(on controller: SettingsVC)
}

class SettingsVC: UIViewController {
    
    //MARK: Properties
    
    weak var delegate: SettingsVCDelegate?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    var user: User? {
        didSet {
            userNameLabel.text = User.shared.name ?? ""
            emailLabel.text = User.shared.email ?? ""
            if User.shared.avatar != nil {
                DispatchQueue.main.async {
                    self.userImageView.sd_setImage(with: URL(string:  PSURL.BasePhotoURL + User.shared.avatar!))
                }
            }
        }
    }
    
    var selectedImage: UIImage?
    
    //MARK: IBActions
    
    @IBAction func changeAvatarButtonPressed(_ sender: Any) {
        self.showActionSheetForUploadingPhoto()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        //TODO: Move to user
        User.shared.token = nil
        guard let loginController = UIStoryboard.login.MainAuth else { return }
        let controller = self.navigationController
        controller?.viewControllers.insert(loginController, at: 0)
        
        controller?.popToRootViewController(animated: true)
    }
    
  fileprivate func uploadImage() {
        
        guard let image = selectedImage else { return }
        
        let data = UIImagePNGRepresentation(image) as NSData?
        User.uploadAvatar(data: data! as Data) { error in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AvatarUpdated"), object: nil)
            }
        }
    }
    
    func getUserInfo() {
        self.user = User.shared
        
        }
    
    private func showActionSheetForUploadingPhoto() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraSheet = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.showImagePickerControllerWithType(.camera)
        })
        
        let librarySheet = UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.showImagePickerControllerWithType(.photoLibrary)
        })
        
        let cancelSheet = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraSheet)
        }
        actionSheet.addAction(librarySheet)
        actionSheet.addAction(cancelSheet)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerWithType(_ type: UIImagePickerControllerSourceType) {
        let picker              = UIImagePickerController()
        picker.delegate         = self
        picker.allowsEditing    = true
        picker.sourceType       = type
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        userImageView.image = chosenImage
        self.selectedImage = chosenImage
        self.uploadImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
