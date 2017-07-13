//
//  StorageService.swift
//  Makestagram
//
//  Created by Connie Guan on 7/11/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    // provide method for uploading images
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1: change image from an UIIamge to Data
        // reduce quality of image
        // if unable to convert image, return nil
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // 2: upload media data to path
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3: check for error
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4: return download URL for image
            completion(metadata?.downloadURL())
        })
    }
}

