//
//  LoginViewController.swift
//  Makestagram1
//
//  Created by Make school on 2/14/18.
//  Copyright © 2018 tamem. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase



class LoginViewController: UIViewController{
    @IBAction func loginButtonTapped(_ sender: Any) {
        //1
        guard let authUI = FUIAuth.defaultAuthUI()
            else {return}
        //2
        authUI.delegate = self
        //3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        if let error = error {
            // create the alert
            let alert = UIAlertController(title: "Error", message: "Try to open VPN.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let user = user
            else { return }
        
//        let userRef = Database.database().reference().child("users").child(user.uid)
//
//            userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
//                if let user = UserModel(snapshot: snapshot) {
//                    print("Welcome back, \(user.username).")
//                } else {
//                    self.performSegue(withIdentifier: "toCreateUsername", sender: self)
//                }
//            })
        
        UserService.show(forUID: user.uid) { (user) in

            if let user = user {
                // handle existing user
                UserModel.setCurrent(user, writeToUserDefaults: true)
                print("welcome back, \(user.username)")

                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                self.performSegue(withIdentifier:Constants.Segue.toCreateUsername, sender: self)
                print("New User")
            }
        }
    }
    
}
