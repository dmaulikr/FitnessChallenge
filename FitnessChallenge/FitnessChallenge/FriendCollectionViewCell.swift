//
//  FriendCollectionViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/9/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func updateWith(athlete: Athlete) {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1).cgColor//Background Dark Gray
        
        if athlete.profileImage != nil {
            profileImageView.image = athlete.profileImage
        } else {
            profileImageView.image = #imageLiteral(resourceName: "Gray user filled")
        }

        usernameLabel.text = athlete.username
        
    }
    
    func updateAddButton() {
        
        profileImageView.image = #imageLiteral(resourceName: "Gray Plus")
        usernameLabel.text = "Add Friend"
    }
}
