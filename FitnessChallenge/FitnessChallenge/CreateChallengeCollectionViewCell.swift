//
//  CreateChallengeCollectionViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/18/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class CreateChallengeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    func updateWith(athlete: Athlete) {
        
        usernameLabel.text = athlete.username
        usernameLabel.textColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).cgColor// Light Gray
        
        if athlete.profileImage != nil {
            profileImageView.image = athlete.profileImage
        } else {
            profileImageView.image = #imageLiteral(resourceName: "UserProfileIcon")
        }
        
        if ChallengeController.sharedController.pendingUsersUids.contains(athlete.uid) {
            checkBoxImageView.image = #imageLiteral(resourceName: "Checked Box")
        } else {
            checkBoxImageView.image = #imageLiteral(resourceName: "emtpy checkbox")
        }
    }
    
    func updateAddButton() {
        
        profileImageView.image = #imageLiteral(resourceName: "Plus Filled-100")
        usernameLabel.text = "Add Friend"
        usernameLabel.textColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
    }
    
}
