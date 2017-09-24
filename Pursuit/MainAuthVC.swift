//
//  LoginVC.swift
//  Pursuit
//
//  Created by Arash Tadayon on 3/24/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit
import KVNProgress

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
        
        struct SeguesIDs {
            static let Trainer  = "ShowTrainerStoryboard"
        }
    }
    //MARK: Variables
    var lastOffSetX = CGFloat()
    
    var services: [DeepLinkService]         = [GuestDeepLinkService()]
    
    
    var changeScrollViewOffSet: Bool = true {
        didSet {
            authStateScrollView.contentOffset.x = changeScrollViewOffSet ? 0 : authStateScrollView.contentSize.width/2
        }
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var authStateScrollView: UIScrollView!
    @IBOutlet weak var logoImageView        : UIImageView!
    @IBOutlet weak var viewForPageController: UIView!
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!{
        didSet {
        }
    }
    @IBOutlet weak var addPhotoButton: UIButton! {
        didSet {
        }
    }
    
    lazy var signInVC: SignInVC? = {
        let loginStoryboard = UIStoryboard(name: Constants.Stroryboard.Login, bundle: nil)
        let signInVC = loginStoryboard.instantiateViewController(withIdentifier: Constants.Identifiers.SignInVC) as? SignInVC
        signInVC?.delegate = self
        
        return signInVC
    }()
    
    lazy var signUpVC: SignUpVC? = {
        let loginStoryboard = UIStoryboard(name: Constants.Stroryboard.Login, bundle: nil)
        let signUpVC = loginStoryboard.instantiateViewController(withIdentifier: Constants.Identifiers.SignUpVC) as? SignUpVC
        signUpVC?.delegate = self
        
        return signUpVC
    }()
    
    lazy var selectTrainerVC: SelectTrainerVC? = {
        let storyboard = UIStoryboard(name: Storyboards.Login, bundle: nil)
        let controller = (storyboard.instantiateViewController(withIdentifier: Controllers.Identifiers.SelectTrainer) as? UINavigationController)?.visibleViewController as? SelectTrainerVC
        controller?.delegate = self
        return controller
    }()
    
    //MARK: IBActions
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        showActionSheetForUploadingPhoto()
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
        
        if let signInController = signInVC, let signUpController = signUpVC {
            controller.tabItems = [(signInController, "SignIn"), (signUpController, "SignUp")]
        }
        
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
        
        let cancelSheet = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheet.addAction(cameraSheet)
        actionSheet.addAction(librarySheet)
        actionSheet.addAction(cancelSheet)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func uploadImage() {
        
        guard let image = profilePhotoImageView.image else { return }
        
        let data = UIImagePNGRepresentation(image) as NSData?
        User.uploadAvatar(data: data! as Data) { error in
            if (error == nil) {
            
            }
        }
    }
}

extension MainAuthVC: TabPageViewControllerDelegate {
    func dispayControllerWithIndex(_ index: Int) {
        changeImagesAccordingControllerIndex(index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffSetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentX = scrollView.contentOffset.x
        let difference = currentX - lastOffSetX
        
        var currentBackgroundOffset = authStateScrollView.contentOffset
        currentBackgroundOffset.x += difference
        authStateScrollView.contentOffset = currentBackgroundOffset
        
        lastOffSetX = currentX
    }
}

private extension MainAuthVC {
    func changeImagesAccordingControllerIndex(_ index: Int) {
        changeScrollViewOffSet = index < 1
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

extension MainAuthVC: SignInVCDelegate {
    func lofinSuccessfull(on: SignInVC) {
        performSegue(withIdentifier: Constants.SeguesIDs.Trainer, sender: self)
    }
    
    
    func signUpSuccessfull(on controller: SignUpVC) {
        
        uploadImage()
        performSegue(withIdentifier: Constants.SeguesIDs.Trainer, sender: self)
    }
}

extension MainAuthVC: SignUpVCDelegate {
    func showSelectTrainerVC(on controller: SignUpVC) {
        if let controller = selectTrainerVC {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension MainAuthVC: SelectTrainerVCDelegate {
    func trainerSelectedWithId(trainer: Trainer) {
        
        signUpVC?.trainer = trainer
        
        selectTrainerVC?.navigationController?.popViewController(animated: true)
    }
}

