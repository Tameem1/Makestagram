//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Make school on 3/10/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import UIKit
class MainTabBarController: UITabBarController {
    
    //MARK : Properties
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoHelper.completionHandler = { image in
            if #available(iOS 10.0, *) {
                PostService.create(for: image)
            } else {
                // Fallback on earlier versions
            }
        }
        delegate = self
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .black
        } else {
            // Fallback on earlier versions
        }
    }
}
extension MainTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            photoHelper.presentActionSheet(from: self)
            return false
        }else {
            return true
        }
    }
}
