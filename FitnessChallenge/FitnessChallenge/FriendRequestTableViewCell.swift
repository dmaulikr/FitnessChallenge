//
//  FriendRequestTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/17/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    weak var delegate: ReloadTableViewDelegate?
    var requesterUsername: String = ""
    

    func updateViews(athleteUsername: String) {
        
        requesterUsername = athleteUsername
        usernameLabel.text = athleteUsername
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
        
        FriendController.shared.declineFriendRequest(requesterUsername: requesterUsername) { 
            delegate?.reloadTableView()
        }
        
    }

    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        FriendController.shared.acceptFriendRequest(requesterUsername: requesterUsername) { 
            delegate?.reloadTableView()
        }
    }
    


}

protocol ReloadTableViewDelegate: class {
    
    func reloadTableView()
}
