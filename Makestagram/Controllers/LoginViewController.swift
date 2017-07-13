//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Connie Guan on 7/10/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // 1: access FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2: set FUIAuth's singleton delegate
        authUI.delegate = self
        
        // 3: present the auth view controller
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }

}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user
            else { return }
            
        //store current user in UserDefaults
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
        }
    }
}
