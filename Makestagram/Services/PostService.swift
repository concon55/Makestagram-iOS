//
//  PostService.swift
//  Makestagram
//
//  Created by Connie Guan on 7/11/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
 
    //create a Post from an image
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    //create a new post JSON object in database
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        // 1: create a reference to current user; need UID
        let currentUser = User.current
        // 2: initialize new Post
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        // 3: convert new post object into a dictionary
        let dict = post.dictValue
        // 4: construct relative path to location where new post data is stored
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        //5: write data to location
        postRef.updateChildValues(dict)
    }
}

