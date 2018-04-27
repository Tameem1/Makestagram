//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Make school on 3/16/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    @available(iOS 10.0, *)
    static let dateFormatter = ISO8601DateFormatter()
    
    @available(iOS 10.0, *)
    static func newPostImageReference() -> StorageReference {
        let uid = UserModel.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
