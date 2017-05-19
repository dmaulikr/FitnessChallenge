//
//  ChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    var currentSegmentIndex: Int = 1 {
        didSet {
            switch currentSegmentIndex {
            case 0: pageTitleLabel.text = "Challenge Invites"
            case 1: pageTitleLabel.text = "Current Challenges"
            case 2: pageTitleLabel.text = "Past Challenges"
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        setupSegmentedControl()
        setupPageTitleLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSegmentedControlFromSwipe(notification:)), name: ChallengeController.sharedController.currentPageIndexNotification, object: nil)
        
        ChallengeController.sharedController.fetchChallenges {
            ChallengeController.sharedController.filterUserPendingChallengeInvites(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: ChallengeController.sharedController.challengesFetchedNotification, object: nil)
                } else {
                    print("Completion was false in 'filterUserPendingChallengeInvites()'")
                }
            })
        }
        
        guard let currentUser = AthleteController.currentUser else { return }
        let url = currentUser.profileImageUrl
        if url != "" {
            DispatchQueue.main.async {
                AthleteController.loadImageFromData(url: url)
            }
        }
        
        FriendController.shared.fetchFriendsList {
            
            FriendController.shared.getFriendProfileImages {
                
                
            }
        }
        FriendController.shared.fetchFriendRequestsReceived()
    }
    
    //=======================================================
    // MARK: - Page title label
    //=======================================================
    
    func setupPageTitleLabel() {
                
        pageTitleLabel.text = "Current Challenges"
    }
    
    //=======================================================
    // MARK: - Segemented Control
    //=======================================================
    
    func setupSegmentedControl() {
        
        segmentedControl.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        segmentedControl.setTitle("Invites", forSegmentAt: 0)
        segmentedControl.setTitle("Current", forSegmentAt: 1)
        segmentedControl.setTitle("Past", forSegmentAt: 2)
        segmentedControl.selectedSegmentIndex = 1
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    @IBAction func segmentedControllerValueChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: self.currentSegmentIndex = 0
        case 1: self.currentSegmentIndex = 1
        case 2: self.currentSegmentIndex = 2
        default:
            break
        }
        
        NotificationCenter.default.post(name: ChallengeController.sharedController.currentSegmentNotification, object: self, userInfo: ["segmentIndex": currentSegmentIndex as Any])
    }
    
    func updateSegmentedControlFromSwipe(notification: Notification) {
        
        guard let index = notification.userInfo?["index"] as? Int else { return }
        segmentedControl.selectedSegmentIndex = index
        self.currentSegmentIndex = index
    }
}
