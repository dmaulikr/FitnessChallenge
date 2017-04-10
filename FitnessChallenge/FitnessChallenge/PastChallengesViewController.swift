//
//  PastChallengesViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/14/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class PastChallengesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //=======================================================
    // MARK: - Outlets
    //=======================================================
    
    @IBOutlet weak var pastChallengesTableView: UITableView!
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    //=======================================================
    // MARK: - Lifecycle functions
    //=======================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        
        pastChallengesTableView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        pastChallengesTableView.separatorStyle = .singleLine
        pastChallengesTableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        pastChallengesTableView.separatorColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 0.25)// Light Gray
    }
    
    //=======================================================
    // MARK: - Tableview Datasource and Delegate
    //=======================================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeController.sharedController.userPastChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastChallengesCell", for: indexPath) as? ChallengeTableViewCell else { return UITableViewCell() }
        let challenge = ChallengeController.sharedController.userPastChallenges[indexPath.row]
        cell.updateWith(challenge: challenge)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge = ChallengeController.sharedController.userPastChallenges[indexPath.row]
        ChallengeController.sharedController.currentlySelectedChallenge = challenge
        self.performSegue(withIdentifier: "pastToCustomTB", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pastToCustomTB" {
            guard let selectedIndex = self.pastChallengesTableView.indexPathForSelectedRow, let destination = segue.destination as? CustomTabBarViewController, let standings = destination.childViewControllers.first as? StandingsViewController else { return }
            
            let challenge = ChallengeController.sharedController.userPastChallenges[selectedIndex.row]
            
            standings.challenge = challenge
        }
    }
}


