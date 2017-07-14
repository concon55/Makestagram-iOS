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
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        // 1: create references to locations where to write data
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        // 2: get array of all follower UIDs
        UserService.followers(for: currentUser) { (followerUIDs) in
            // 3: construct a timeline JSON object to store current user's uid
            let timelinePostDict = ["poster_uid" : currentUser.uid]
            
            // 4: create a mutable dictionary that will store all of the data to be written in database
            //initialize: write current timeline dictionary to own timeline
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            // 5: add post to each of follower's timelines
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            // 6: write post
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            // 7: write multi-location update to database
            rootRef.updateChildValues(updatedData)
        }
    }
    
    //fetch an individual post using postKey and posterUID
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
}

