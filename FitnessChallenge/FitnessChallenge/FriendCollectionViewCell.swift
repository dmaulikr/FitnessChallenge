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
    
//    var athlete: Athlete?
    
    func updateWith(athlete: Athlete) {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.image = athlete.profileImage

        usernameLabel.text = athlete.username
    }
    
    func updateAddButton() {
        
        profileImageView.image = #imageLiteral(resourceName: "Plus Filled-100")
        usernameLabel.text = "Add Friend"
    }
}
