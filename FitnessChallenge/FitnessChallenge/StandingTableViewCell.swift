//
//  StandingTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 7/27/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class StandingTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var athleteDictionary: [Athlete:Int]? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let athleteDictionary = athleteDictionary else { print("athleteDictionary was nil in StandingTableViewCell."); return }
        
        nameLabel.text = athleteDictionary.keys.first!.username
        repsLabel.text = "\(athleteDictionary.values.first!)"
    }

}
