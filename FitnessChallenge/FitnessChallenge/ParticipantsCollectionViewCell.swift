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
        
        profilePhotoImageView.image = athlete.profileImage
        usernameLabel.text = athlete.username
    }
    
}
