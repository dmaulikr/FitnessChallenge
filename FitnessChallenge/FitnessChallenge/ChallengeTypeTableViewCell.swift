//
//  ChallengeTypeTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/8/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengeTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var challengeTypeLabel: UILabel!
    
    func setupViews(challengeType: [String:Any]) {
        
        self.cellView.layer.cornerRadius = 30
//        self.cellView.layer.shadowRadius = 5
//        self.cellView.layer.shadowColor = UIColor.black.cgColor
//        self.cellView.layer.shadowPath = UIBezierPath(roundedRect: cellView.layer.frame, cornerRadius: 30.0).cgPath
////        self.cellView.layer.shadowPath = UIBezierPath(rect: cellView.bounds).cgPath
//        self.cellView.layer.shadowOpacity = 1.0
//        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.cellView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        
        self.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        guard let label = challengeType["label"] as? String else { return }
        
        challengeTypeLabel.text = label
    }
    
}
