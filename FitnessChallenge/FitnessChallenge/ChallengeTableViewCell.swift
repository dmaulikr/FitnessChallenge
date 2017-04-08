//
//  ChallengeTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/19/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var creatorUsernameLabel: UILabel!
  
    func updateWith(challenge: Challenge) {
        
        challengeNameLabel.text = challenge.name
        challengeNameLabel.textColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
        creatorUsernameLabel.text = challenge.creatorUsername
//        creatorUsernameLabel.textColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
        
        self.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
    }

}
