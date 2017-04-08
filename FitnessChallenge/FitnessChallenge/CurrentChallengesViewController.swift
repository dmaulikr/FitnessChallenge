//
//  CurrentChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/14/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class CurrentChallengesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //=======================================================
    // MARK: - Outlets
    //=======================================================
    
    @IBOutlet weak var currentChallengesTableView: UITableView!
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    //=======================================================
    // MARK: - Lifecycle functions
    //=======================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentChallengesTableView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        currentChallengesTableView.separatorStyle = .singleLine
        currentChallengesTableView.rowHeight = 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(challengesWereFetched), name: ChallengeController.sharedController.challengesFetchedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        currentChallengesTableView.reloadData()
    }
    //=======================================================
    // MARK: - Tableview Datasource and Delegate
    //=======================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeController.sharedController.userCurrentChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentChallengesCell", for: indexPath) as? ChallengeTableViewCell else { return UITableViewCell() }
        let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
        cell.updateWith(challenge: challenge)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge = ChallengeController.sharedController.userCurrentChallenges[indexPath.row]
        ChallengeController.sharedController.currentlySelectedChallenge = challenge
        
        self.performSegue(withIdentifier: "currentToCustomTB", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentToCustomTB" {
            guard let selectedIndex = self.currentChallengesTableView.indexPathForSelectedRow, let destination = segue.destination as? CustomTabBarViewController, let standings = destination.childViewControllers.first as? StandingsViewController else { return }
            
            let challenge = ChallengeController.sharedController.userCurrentChallenges[selectedIndex.row]
            
            standings.challenge = challenge
        }
    }
    
    //=======================================================
    // MARK: - Challenges Fetched Notification Target Function
    //=======================================================
    
    func challengesWereFetched() {
        currentChallengesTableView.reloadData()
    }
}

