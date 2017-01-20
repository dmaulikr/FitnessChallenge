//
//  ChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var invitesTableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var currentChallengesTableView: UITableView!
    @IBOutlet weak var pastChallengesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChallengeController.sharedController.fetchChallenges {
            self.currentChallengesTableView.reloadData()
        }
        
        FriendController.shared.fetchFriendRequestsReceived()
        
        FriendController.shared.fetchFriendsList()
        
        guard let currentUser = AthleteController.currentUser else { return }
        let url = currentUser.profileImageUrl
        if url != "" {
            DispatchQueue.main.async {
                AthleteController.loadImageFromData(url: url)
            }
        }
        
        FriendController.shared.getFriendProfileImages { 
            
        }
        
        guard let username = AthleteController.currentUser?.username else { return }
        self.welcomeLabel.text = "Welcome \(username)!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentChallengesTableView.reloadData()
    }
    
    //=======================================================
    // MARK: - TableView DataSource and Delegate Functions
    //=======================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView ==  invitesTableView {
            return ChallengeController.sharedController.userChallengeInvites.count
        } else if tableView == currentChallengesTableView {
            return ChallengeController.sharedController.userCurrentChallenges.count
        } else {
            return ChallengeController.sharedController.userPastChallenges.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentChallengeCell", for: indexPath) as? ChallengeTableViewCell else { return UITableViewCell() }
        if tableView == invitesTableView {
            let challenge = ChallengeController.sharedController.userChallengeInvites[indexPath.row]
            cell.updateWith(challenge: challenge)
        } else if tableView == currentChallengesTableView {
            let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
            cell.updateWith(challenge: challenge)
        } else {
            let challenge = ChallengeController.sharedController.userPastChallenges[indexPath.row]
            cell.updateWith(challenge: challenge)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == invitesTableView {
            // Present way of joining or declining.
            let challenge = ChallengeController.sharedController.userChallengeInvites[indexPath.row]
            ChallengeController.sharedController.currentlySelectedChallenge = challenge
        } else if tableView == currentChallengesTableView {
            let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
            ChallengeController.sharedController.currentlySelectedChallenge = challenge
        } else {
            let challenge = ChallengeController.sharedController.userPastChallenges[indexPath.row]
            ChallengeController.sharedController.currentlySelectedChallenge = challenge
        }
        
        self.performSegue(withIdentifier: "showChallengeView", sender: self)
    }
    
    //=======================================================
    // MARK: - Helper Functions
    //=======================================================
    
    func presentJoinOrDeclineAlert(challenge: Challenge) {
        
        let alertController = UIAlertController(title: "Oh no!", message: "We couldn't get you signed in. Please try again.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let joinAction = UIAlertAction(title: "Join", style: .default) { (_) in
            //
        }
        let declineAction = UIAlertAction(title: "Decline", style: .default) { (_) in
            guard let index = ChallengeController.sharedController.userChallengeInvites.index(of: challenge) else { return }
            
//            ChallengeController.sharedController.userChallengeInvites.remove(at: index)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(joinAction)
        alertController.addAction(declineAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //=======================================================
    // MARK: - Navigation
    //=======================================================
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do if segue.identifier later
        if segue.identifier == "showChallengeView" {
            guard let selectedIndex = self.currentChallengesTableView.indexPathForSelectedRow, let destination = segue.destination as? CustomTabBarViewController, let standings = destination.childViewControllers.first as? StandingsViewController else { return }
            
            let challenge = ChallengeController.sharedController.allChallenges[selectedIndex.row]
            
            standings.challenge = challenge
            
        }
        
    }
    
    
}
