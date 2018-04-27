//
//  PostService.swift
//  Makestagram
//
//  Created by Make school on 3/15/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
struct PostService {
    
    @available(iOS 10.0, *)
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
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = UserModel.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        // 1 We create references to the important locations
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        // 2 Use our class method to get an array of all of our follower UIDs
        UserService.followers(for: currentUser) { (followerUIDs) in
            // 3 We construct a timeline JSON object where we store our current user's uid.
            let timelinePostDict = ["poster_uid" : currentUser.uid]
            
            // 4 We create a mutable dictionary that will store all of the data we want to write to our database
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            // 5 We add our post to each of our follower's timelines.
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            // 6 We make sure to write the post we are trying to create.
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            // 7 We write our multi-location update to our database.
            rootRef.updateChildValues(updatedData)
        }
    }
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
