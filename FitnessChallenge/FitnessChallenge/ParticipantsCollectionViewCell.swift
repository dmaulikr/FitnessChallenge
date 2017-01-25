//
//  ParticipantsCollectionViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/19/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ParticipantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    func updateWith(athlete: Athlete) {
        
        usernameLabel.text = athlete.username
        usernameLabel.textColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width / 2
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.layer.borderWidth = 2.0
        profilePhotoImageView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).cgColor// Light Gray
        
        if athlete.profileImage != nil {
            profilePhotoImageView.image = athlete.profileImage
        } else {
            profilePhotoImageView.image = #imageLiteral(resourceName: "UserProfileIcon")
        }
        
    }
    
}
