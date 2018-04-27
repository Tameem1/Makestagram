//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Make school on 2/22/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController : UIViewController{
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        
        UserService.create(firUser, username: username) { (user) in
        guard let user = user else { return }
            
        UserModel.setCurrent(user, writeToUserDefaults: true)
            
        print("Created new user: \(user.username)")
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
