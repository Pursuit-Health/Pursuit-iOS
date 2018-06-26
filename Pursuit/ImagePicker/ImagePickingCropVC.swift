//
//  ImagePickingCropVC.swift
//  Inspection
//
//  Created by Volodymyr Khmil on 1/12/17.
//  Copyright © 2017 Inspection. All rights reserved.
//

import Foundation
import TOCropViewController
import Photos

protocol ImagePickingCropVCDelegate: class {
    func imagePicker(picker: ImagePickingCropVC, didSelectOriginalImage: UIImage, croppedImage: UIImage)
    func imagePickerCancel(picker: ImagePickingCropVC)
}

@objc class ImagePickingCropVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    weak var delegate: ImagePickingCropVCDelegate?
    var imagePickerController: UIImagePickerController?
    
    //MARK: Public.Methods
    
    func initialise(controller: UIViewController, view: UIView) {
        self.selectType(for: controller, view: view)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerEditedImage] ??
            info[UIImagePickerControllerOriginalImage] ??
            info[UIImagePickerControllerCropRect]) as? UIImage else {
                return
        }
        self.startCropping(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.imagePickerCancel(picker: self)
    }
    
    //MARK: Private
    
    private func actionFor(sourceType: UIImagePickerControllerSourceType, with name: String, controller: UIViewController) -> UIAlertAction? {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return UIAlertAction(title: name, style: .default) { (action) in
                controller.dismiss(animated: true, completion: nil)
                self.startSelecting(with: sourceType)
                controller.present(self, animated: true, completion: nil)
            }
        }
        return nil
    }
    
    private func selectType(for controller: UIViewController, view: UIView) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let actions: [(UIImagePickerControllerSourceType, String)] = [(.camera, "Take Photo"), (.savedPhotosAlbum, "Choose Photo")]
        for action in actions {
            if let action = self.actionFor(sourceType: action.0, with: action.1, controller: controller) {
                alert.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.delegate?.imagePickerCancel(picker: self)
        }
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = view
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    private func startSelecting(with type: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = type
        pickerController.delegate = self
        
        self.view.addSubview(pickerController.view)
        self.view.addConstraints(UIView.place(pickerController.view, onOtherView: self.view))
        pickerController.didMove(toParentViewController: self)
        self.addChildViewController(pickerController)
    }
    
    private func startCropping(image: UIImage) {
        let cropController: TOCropViewController = TOCropViewController(image: image)
        cropController.delegate = self
        cropController.aspectRatioPreset = .presetCustom
        cropController.customAspectRatio = CGSize(width: 1, height: 1)
        cropController.aspectRatioLockEnabled = true
        cropController.resetAspectRatioEnabled = false
        self.present(cropController, animated: false, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        if cancelled {
            cropViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
       delegate?.imagePicker(picker: self, didSelectOriginalImage: image, croppedImage: image)
    }
}
