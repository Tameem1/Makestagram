//
//  Storyboard+Utility.swift
//  Makestagram
//
//  Created by Make school on 3/3/18.
//  Copyright © 2018 tamem. All rights reserved.
//

import Foundation
import UIKit
extension UIStoryboard {
    //1
    enum MGType : String {
        case main
        case login
        
        var filename : String {
            return rawValue.capitalized
        }
    }
    
    //2
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    //3
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
}
