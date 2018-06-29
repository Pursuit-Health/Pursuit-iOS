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

protocol SettingsVCDelegate: class {
    func logoutPressed(on controller: SettingsVC)
}

class SettingsVC: UIViewController {
    
    enum CellType {
        case profile(user: User?)
        case weight(delegate: WeightsTableViewCellDelegate)
        case template
        case request
        case logout(delegate: LogoutTableViewCellDelegate)
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .profile:
                return UserInfoTableViewCell.self
            case .weight:
                return WeightsTableViewCell.self
            case .template:
                return TemplateSettingsCell.self
            case .request:
                return RequestsTableViewCell.self
            case .logout:
                return LogoutTableViewCell.self
            }
        }
        
        func fillCell(cell: UITableViewCell) {
            switch self {
            case .profile(let user):
                if let castedCell = cell as? UserInfoTableViewCell {
                    fillUserInfoCell(castedCell, user: user)
                }
            case .weight(let delegate):
                if let castedCell = cell as? WeightsTableViewCell {
                    fillWeightCell(castedCell, delegate: delegate)
                }
            case .template:
                if let castedCell = cell as? TemplateSettingsCell {
                    fillTemplateSettingCell(castedCell)
                }
            case .request:
                if let castedCell = cell as? RequestsTableViewCell {
                    fillRequestCell(castedCell)
                }
            case.logout(let delegate):
                if let castedCell = cell as? LogoutTableViewCell {
                    fillLogoutCell(castedCell, delegate: delegate)
                }
            }
        }
        
        private func fillUserInfoCell(_ cell: UserInfoTableViewCell, user: User?) {
            if let user = user {
                cell.configureWith(user: user)
            }
        }
        
        private func fillWeightCell(_ cell: WeightsTableViewCell, delegate: WeightsTableViewCellDelegate) {
            cell.delegate = delegate
        }
        
        private func fillLogoutCell(_ cell: LogoutTableViewCell, delegate: LogoutTableViewCellDelegate){
            cell.delegate = delegate
        }
        
        private func fillTemplateSettingCell(_ cell: TemplateSettingsCell){

        }
        
        private func fillRequestCell(_ cell: RequestsTableViewCell) {

        }
    }
    
    //MARK: Properties
    
    weak var delegate: SettingsVCDelegate?
    
     var cellsInfo: [CellType] {
        if self.isClient() {
            return [.profile(user: self.user), .weight(delegate: self), .logout(delegate: self)]
        }else {
            return [.profile(user: self.user), .weight(delegate: self), .template, .request, .logout(delegate: self)]
        }
    }
    
    var templatesListVC: SavedTemplatesVC {
        return UIStoryboard.trainer.SavedTemplatesList!
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.rowHeight             = UITableViewAutomaticDimension
            settingsTableView.estimatedRowHeight    = 100
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    var selectedImage: UIImage?
    
    var savedTemplatesCoordinator: SavedTemplatesCoordinator = SavedTemplatesCoordinator()
    
    var clientsRequestCoordinator: ClientsRequestCoordinator = ClientsRequestCoordinator()
    
    //MARK: IBActions
    
    @IBAction func changeAvatarButtonPressed(_ sender: Any) {
        //self.showActionSheetForUploadingPhoto()
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setAppearence()
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
        guard let loginController = UIStoryboard.login.MainAuth else { return }
        //controller?.viewControllers.insert(loginController, at: 0)
        
        self.navigationController?.setViewControllers([loginController], animated: true)
        
        //controller?.popToRootViewController(animated: true)
    }
    
  fileprivate func uploadImage() {
        
    guard let image = selectedImage else { return }
    
    guard let data = image.compressTo(1000000) as Data? else { return }
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
    
    private func isClient() -> Bool {
        return User.shared.coordinator is ClientCoordinator
    }
    
    func getUserInfo() {
        self.user = User.shared
    }
    
    fileprivate func coordinateWith(_ coordinator: Coordinator) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self)
        }
        
        let last = (self.revealViewController().frontViewController as? UINavigationController)?.viewControllers.last as? NavigatorVC
        let tabBarSelectedVC = last?.tabBarVC?.selectedViewController
        coordinator.start(from: tabBarSelectedVC)
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = cellsInfo[indexPath.row]
         guard let cell = tableView.gc_dequeueReusableCell(type: cellInfo.cellType) else { return UITableViewCell() }
        cellInfo.fillCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = cellsInfo[indexPath.row]
        switch cellInfo {
        case .template:
            coordinateWith(savedTemplatesCoordinator)
        case .request:
            coordinateWith(clientsRequestCoordinator)
        default:
            break
        }
    }
}

extension SettingsVC: UserInfoTableViewCellDelegate {
    func userDidPressedChangePhoto(on cell: UserInfoTableViewCell) {
        let cropper = ImagePickingCropVC()
        cropper.initialise(controller: self, view: self.view)
        cropper.delegate = self
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

extension SettingsVC: ImagePickingCropVCDelegate {
    func imagePicker(picker: ImagePickingCropVC, didSelectOriginalImage: UIImage, croppedImage: UIImage) {
        self.selectedImage = croppedImage
        self.uploadImage()
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerCancel(picker: ImagePickingCropVC) {
        self.dismiss(animated: true, completion: nil)
    }
}
