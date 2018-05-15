//
//  SettingsVC.swift
//  Pursuit
//
//  Created by ігор on 10/11/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
//
//class SettingsVC: UIViewController {
//
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var emailLabel: UILabel!
//    var user: User? {
//        didSet {
//            userNameLabel.text = User.shared.name ?? ""
//            emailLabel.text = User.shared.email ?? ""
//            if User.shared.avatar != nil {
//                userImageView.sd_setImage(with: URL(string:  PSURL.BaseURL + User.shared.avatar! ))
//            }else {
//                userImageView.image = UIImage(named: "photo-camera-2")
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.getUserInfo()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    @IBAction func logoutButtonPressed(_ sender: Any) {
//
//        //TODO: Move to user
//        User.shared.token = nil
//        User.shared.firToken = nil
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//
//
//        if navigationController != nil {
//            let loginController = UIStoryboard.login.MainAuth!
//            let controller = navigationController
//            controller?.viewControllers.insert(loginController, at: 0)
//
//            controller?.popToRootViewController(animated: true)
//        }else {
//            let instantiate = UIStoryboard.login.preloadNavigation!
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = instantiate
//        }
//    }
//
//    func getUserInfo() {
//        User.getUserInfo { (user, error) in
//            if error == nil {
//                self.user = user
//            }
//        }
//    }
//}

class SettingsVC: UIViewController {

    //MARK: Enums

    enum SettingsType: Int {
        case profile    = 0
        case weight     = 1
        case logout     = 2
    }

    //MARK: IBOutlets

    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.rowHeight             = UITableViewAutomaticDimension
            settingsTableView.estimatedRowHeight    = 100
        }
    }
    
    var user: User? {
        didSet {
            self.settingsTableView.reloadData()
            
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

    fileprivate func logOut() {
        //TODO: Move to user
        User.shared.token = nil
        User.shared.firToken = nil
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if navigationController != nil {
            let loginController = UIStoryboard.login.MainAuth!
            let controller = navigationController
            controller?.viewControllers.insert(loginController, at: 0)
            
            controller?.popToRootViewController(animated: true)
        }else {
            let instantiate = UIStoryboard.login.preloadNavigation!
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = instantiate
        }
    }

    fileprivate func uploadImage() {

        guard let image = selectedImage else { return }

        guard let data = UIImagePNGRepresentation(image) as Data? else { return }
        User.uploadAvatar(data: data) { error in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AvatarUpdated"), object: nil)
                self.reloadUserInfo()
            }
        }
    }
    
    private func reloadUserInfo() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.settingsTableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func getUserInfo() {
        User.getUserInfo { (user, error) in
            if let user = user {
                self.user = user
                self.reloadUserInfo()
            }else {
                if let error = error {
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.present(error.alert(action: action), animated: true, completion: nil)
                }
            }
        }
    }

    fileprivate func showActionSheetForUploadingPhoto() {
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

    fileprivate func typeForIndex(_ index: Int) -> SettingsType {
        return SettingsType(rawValue: index) ?? .profile
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return buildTableView(tableView, indexPath: indexPath)
    }

    func buildTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let settingsType = self.typeForIndex(indexPath.row)
        var cell: UITableViewCell? = UITableViewCell()
        switch settingsType {
        case .profile:
            if let castedCell = tableView.gc_dequeueReusableCell(type: UserInfoTableViewCell.self) {
                castedCell.delegate = self
                cell = fillUserInfoCell(castedCell)
            }
        case .weight:
            if let castedCell = tableView.gc_dequeueReusableCell(type: WeightsTableViewCell.self) {
                cell = fillWeightCell(castedCell)
            }
        case .logout:
            if let castedCell = tableView.gc_dequeueReusableCell(type: LogoutTableViewCell.self){
                cell = fillLogoutCell(castedCell)
            }
        }
        return cell ?? UITableViewCell()
    }

    func fillUserInfoCell(_ cell: UserInfoTableViewCell) -> UserInfoTableViewCell {
        if let user = self.user {
            cell.configureWith(user: user)
        }
        return cell
    }

    func fillWeightCell(_ cell: WeightsTableViewCell) -> WeightsTableViewCell {
        cell.delegate = self
        return cell
    }

    func fillLogoutCell(_ cell: LogoutTableViewCell) -> LogoutTableViewCell{
        cell.delegate = self
        return cell
    }
}

extension SettingsVC: UserInfoTableViewCellDelegate {
    func userDidPressedChangePhoto(on cell: UserInfoTableViewCell) {
        showActionSheetForUploadingPhoto()
    }
}

extension SettingsVC: WeightsTableViewCellDelegate {
    func userDidChangeWeightsType(type: WeightsType, on cell: WeightsTableViewCell) {
        UserSettings.shared.weightsType = type
    }
}

extension SettingsVC: LogoutTableViewCellDelegate {
    func logoutButtonPressedOn(_ cell: LogoutTableViewCell) {
        logOut()
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
        self.selectedImage = chosenImage
        self.uploadImage()
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
