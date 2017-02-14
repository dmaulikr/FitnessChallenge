//
//  ChallengeTypeTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/8/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengeTypeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var challengeTypeImageView: UIImageView!
    @IBOutlet weak var challengeTypeLabel: UILabel!

    func setupViews(challengeType: [String:Any]) {
        
        guard let image = challengeType["image"] as? UIImage,
            let label = challengeType["label"] as? String else { return }
        
        challengeTypeImageView.image = image
        challengeTypeLabel.text = label
    }

}
