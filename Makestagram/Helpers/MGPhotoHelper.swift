//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Connie Guan on 7/11/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    
    // MARK: - Properties
    
    //called when user has selected a photo from UIImagePickerController
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    //takes a reference to a view controller as a reference
    func presentActionSheet(from viewController: UIViewController) {
        // 1: initialize a new UIAlertController
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // 2: check if current device has camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
        }
        
        // 6: add cancel action to close UIAlertController action sheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 7: present UIAlertController from UIViewController
        viewController.present(alertController, animated: true)
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        //create a new instance of UIImagePickerController which will present a native UI component that will allow user to take/choose photo
        let imagePickerController = UIImagePickerController()
        //set sourceType to determine whether UIImagePickerController will activate camera and display photo taking over lay or show user's photo library
        imagePickerController.sourceType = sourceType
        //to gain access to image a user has selected, use delegation; become delegate of the UIImagePickerController
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }

}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
