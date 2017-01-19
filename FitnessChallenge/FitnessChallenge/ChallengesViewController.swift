//
//  ChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var currentChallengesTableView: UITableView!
    
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
    
    // Current Challenges TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeController.sharedController.userCurrentChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentChallengeCell", for: indexPath)
        
        let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
        
        
        cell.textLabel?.text = challenge.name
        cell.detailTextLabel?.text = challenge.creatorUsername
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
        
        ChallengeController.sharedController.currentlySelectedChallenge = challenge
        
        self.performSegue(withIdentifier: "showChallengeView", sender: self)
    }
    
    
    // MARK: - Navigation
    
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
