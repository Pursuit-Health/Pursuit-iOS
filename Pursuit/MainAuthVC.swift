//
//  LoginVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import KVNProgress

protocol MainAuthVCDelegate: class {
    func signUpButtonPressedMainAuthVC()
    func signInButtonPressedMainAuthVC()
}
    //IGOR: Check
class MainAuthVC: UIViewController {
    
    //MARK: Constants 

    struct Constants {
        struct Stroryboard {
            static let Login    = "Login"
        }
        struct Identifiers {
            static let SignUpVC = "SignUpVCID"
            static let SignInVC = "SignInVCID"
        }
    }
    //MARK: Variables
    
    weak var delegate: MainAuthVCDelegate?
    
    var services: [DeepLinkService]         = [GuestDeepLinkService()]

    
    var isHiddenProfileImage: Bool = true {
        didSet {
            profilePhotoImageView.isHidden  = isHiddenProfileImage
            addPhotoButton.isHidden         = isHiddenProfileImage
            logoImageView.isHidden          = !isHiddenProfileImage
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var logoImageView        : UIImageView!
    @IBOutlet weak var viewForPageController: UIView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!{
        didSet {
            profilePhotoImageView.isHidden = true
        }
    }
    @IBOutlet weak var addPhotoButton: UIButton! {
        didSet {
            addPhotoButton.isHidden = true
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        //showActionSheetForUploadingPhoto()
        uploadImage()
    }
    
    //MARK: LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: Private
    
    private func getControllers(){
        let controller = TabPageViewController.create()
        
        controller.tabPageVCDelegate = self
        let loginStoryboard = UIStoryboard(name: Constants.Stroryboard.Login, bundle: nil)
        
        let signInVC = loginStoryboard.instantiateViewController(withIdentifier: Constants.Identifiers.SignInVC)
        let signUpVC = loginStoryboard.instantiateViewController(withIdentifier: Constants.Identifiers.SignUpVC)
        
        controller.tabItems = [(signInVC, "SignIn"), (signUpVC, "SignUp")]
        
        setUpOptions(controller)
        
        setUpControllerToMainView(controller)
        
    }
    
    private func setUpOptions(_ controller: TabPageViewController) {
        var option                  = TabPageOption()
        option.currentBarHeight     = 3.0
        option.tabWidth             = view.frame.width / CGFloat(controller.tabItems.count)
        option.tabBackgroundColor   = .clear
        option.currentColor         = UIColor.customAuthButtons()
        controller.option           = option
    }
    
    private func setUpControllerToMainView(_ controller: TabPageViewController) {
        addChildViewController(controller)
        self.viewForPageController.addSubview(controller.view)
        self.viewForPageController.addConstraints(UIView.place(controller.view, onOtherView: viewForPageController))
        
        controller.didMove(toParentViewController: self)
    }
    
    private func showActionSheetForUploadingPhoto() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraSheet = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
        self.showImagePickerControllerWithType(.camera)
        })
        
        let librarySheet = UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.showImagePickerControllerWithType(.photoLibrary)
        })
        
        actionSheet.addAction(cameraSheet)
        actionSheet.addAction(librarySheet)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func uploadImage() {
        let image = UIImage(named: "avatar1")
        let data = UIImagePNGRepresentation(image!) as NSData?
        User.uploadAvatar(data: data! as Data) { success in
            
        }
    }
}

extension MainAuthVC: TabPageViewControllerDelegate {
    func dispayControllerWithIndex(_ index: Int) {
        changeImagesAccordingControllerIndex(index)
    }
}

private extension MainAuthVC {
    func changeImagesAccordingControllerIndex(_ index: Int) {
        isHiddenProfileImage = index < 1
    }
}

extension MainAuthVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerWithType(_ type: UIImagePickerControllerSourceType) {
        let picker              = UIImagePickerController()
        picker.delegate         = self
        picker.allowsEditing    = true
        picker.sourceType       = type
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        profilePhotoImageView.image = chosenImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


