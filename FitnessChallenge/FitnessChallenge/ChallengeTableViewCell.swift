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
    @IBOutlet weak var endDateLabel: UILabel!
  
    func updateWith(challenge: Challenge) {
        
        challengeNameLabel.text = challenge.name
        creatorUsernameLabel.text = challenge.creatorUsername
        endDateLabel.text = "\(challenge.endDate)"
    }

}
