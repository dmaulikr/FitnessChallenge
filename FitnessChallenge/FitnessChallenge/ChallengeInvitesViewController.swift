//
//  ChallengeInvitesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/14/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengeInvitesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //=======================================================
    // MARK: - Outlets
    //=======================================================
    
    @IBOutlet weak var invitesTableView: UITableView!
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    
    
    //=======================================================
    // MARK: - Lifecycle functions
    //=======================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(invitesDidLoad), name: ChallengeController.sharedController.challengesFetchedNotification, object: nil)
    }
    
    func setupTableView() {
        
        invitesTableView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        invitesTableView.separatorStyle = .singleLine
        invitesTableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        invitesTableView.separatorColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 0.25)// Light Gray
    }
    
    //=======================================================
    // MARK: - Tableview datasource and delegate
    //=======================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChallengeController.sharedController.userPendingChallengeInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as? ChallengeTableViewCell else { return UITableViewCell() }
        
        let challenge = ChallengeController.sharedController.userPendingChallengeInvites[indexPath.row]
        cell.updateWith(challenge: challenge)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present way of joining or declining.
        let challenge = ChallengeController.sharedController.userPendingChallengeInvites[indexPath.row]
        presentJoinOrDeclineAlert(challenge: challenge)
        //            ChallengeController.sharedController.currentlySelectedChallenge = challenge
        self.performSegue(withIdentifier: "invitesToCustomTB", sender: self)
    }
    
    //=======================================================
    // MARK: - Helper Functions
    //=======================================================
    
    func presentJoinOrDeclineAlert(challenge: Challenge) {
        
        let alertController = UIAlertController(title: "Choose what you'd like to do with this challenge.", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let joinAction = UIAlertAction(title: "Join", style: .default) { (_) in
            ChallengeController.sharedController.acceptRequestToJoinChallenge(challenge: challenge, completion: {
                self.invitesTableView.reloadData()
            })
        }
        let declineAction = UIAlertAction(title: "Decline", style: .default) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(joinAction)
        alertController.addAction(declineAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invitesToCustomTB" {
            guard let selectedIndex = self.invitesTableView.indexPathForSelectedRow, let destination = segue.destination as? CustomTabBarViewController, let standings = destination.childViewControllers.first as? StandingsViewController else { return }
            
            let challenge = ChallengeController.sharedController.userPendingChallengeInvites[selectedIndex.row]
            
            standings.challenge = challenge
        }
    }
    
    //=======================================================
    // MARK: - Challenges Fetched notification target function
    //=======================================================
    
    func invitesDidLoad() {
        invitesTableView.reloadData()
    }
}
