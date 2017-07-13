//
//  FollowService.swift
//  Makestagram
//
//  Created by Connie Guan on 7/13/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService{
    
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        //1: create a dictionary to update multiple locations at the same time. Set key-value for followers and following
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true, "following/\(currentUID)/\(user.uid)" : true]
        
        //2: write new relationship to Firebase
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            //3: return whether update was successful
            success(error == nil)
        }
    }
    
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(), "following/\(currentUID)/\(user.uid)" : NSNull()]
        
               let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            success(error == nil)
        }
    }
    
    //set the follow relationship between two users
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
