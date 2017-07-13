//
//  User.swift
//  Makestagram
//
//  Created by Connie Guan on 7/10/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    var isFollowed = false
    
    // MARK: - Singleton
    
    // 1: create private static variable to hold current user
    private static var _current: User?
    
    // 2: create computed variable that only has a getter that can access the private _current variable
    static var current: User {
        
        // 3: check that _current is of type User? isn't nil
        //if nil and is being read, fatalError()
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4: if not nil, returned to the user
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 1: take a Bool on whether user should be written to UserDefaults
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
       
        // 2: check if Bool is true. If so, write user object to UserDefaults
        if writeToUserDefaults {
            
            // 3: use NSKeyedArchiver to turn user object into Data
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4: store data for current user with correct key in UserDefaults
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    
    //MARK: - Properties
    
    let uid: String
    let username: String
    
    //MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        //require the snapshot to be casted to a dictionary and check that the dictionary contains username key/value
        guard let dict = snapshot.value as? [String : Any],
        let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}


