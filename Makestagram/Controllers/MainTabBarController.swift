//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Connie Guan on 7/11/17.
//  Copyright © 2017 Connie Guan. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //closure
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        // 1: set the MainTabBarController as the delegate of its tab bar
        delegate = self
        // 2: set the tab bar's unselectedItemTintColor from the default of gray to black
        tabBar.unselectedItemTintColor = .black
    }
}

//if view controller's tag is center tag, return false and present action sheet to allow user to capture or upload photo
//if not center tag, return true and let tab bar controller behave as usual
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
