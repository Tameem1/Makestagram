//
//  FollowService.swift
//  Makestagram
//
//  Created by Make school on 3/31/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
struct FollowService {
    private static func followUser(_ user: UserModel, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = UserModel.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
        // 1
        UserService.posts(for: user) { (posts) in
            // 2
            let postKeys = posts.flatMap { $0.key }
            
            // 3
            var followData = [String : Any]()
            let timelinePostDict = ["poster_uid" : user.uid]
            postKeys.forEach { followData["timeline/\(currentUID)/\($0)"] = timelinePostDict }
            
            // 4
            ref.updateChildValues(followData, withCompletionBlock: { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                // 5
                success(error == nil)
            })
        }
    }
    
    
    
    
    
    
    private static func unfollowUser(_ user: UserModel, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = UserModel.current.uid
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        // http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            UserService.posts(for: user, completion: { (posts) in
                var unfollowData = [String : Any]()
                let postsKeys = posts.flatMap { $0.key }
                postsKeys.forEach {
                    // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
                    unfollowData["timeline/\(currentUID)/\($0)"] = NSNull()
                }
                
                ref.updateChildValues(unfollowData, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    success(error == nil)
                })
            })
        }
    }

    
    
    
    
    
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: UserModel, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    
    
    
    
    
    static func isUserFollowed(_ user: UserModel, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = UserModel.current.uid
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
