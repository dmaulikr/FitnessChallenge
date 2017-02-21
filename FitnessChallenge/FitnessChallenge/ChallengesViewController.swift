//
//  ChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        ChallengeController.sharedController.fetchChallenges {
            ChallengeController.sharedController.filterUserPendingChallengeInvites(completion: { (success) in
                if success {
                    // Call delegate func to reloadData tableView on challengeInvitesTableViewController
                    print("hi")
                } else {
                    print("Completion was false in 'filterUserPendingChallengeInvites()'")
                }
            })
//            self.currentChallengesTableView.reloadData()
//            self.invitesTableView.reloadData()
//            self.pastChallengesTableView.reloadData()
        }
        
        FriendController.shared.fetchFriendsList()
        FriendController.shared.fetchFriendRequestsReceived()
        
        guard let currentUser = AthleteController.currentUser else { return }
        let url = currentUser.profileImageUrl
        if url != "" {
            DispatchQueue.main.async {
                AthleteController.loadImageFromData(url: url)
            }
        }
        
        FriendController.shared.getFriendProfileImages { 
//            self.currentChallengesTableView.reloadData()
//            self.invitesTableView.reloadData()
//            self.pastChallengesTableView.reloadData()
        }
//        
//        guard let username = AthleteController.currentUser?.username else { return }
//        self.welcomeLabel.text = "Welcome   \(username)!"
//        self.welcomeLabel.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
    }
    
    
    
}

