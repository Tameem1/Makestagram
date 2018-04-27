//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Make school on 3/25/18.
//  Copyright © 2018 tamem. All rights reserved.
//


import UIKit
class PostHeaderCell: UITableViewCell {
    static let height: CGFloat = 54
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        print("options button tapped")
    }
}
