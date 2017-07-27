//
//  StandingsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import ResearchKit

class StandingsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentUserSets: [ORKValueStack] = []
    
    var challenge: Challenge?
    
    let chartColors = [
        UIColor(red: 225/255, green: 90/255, blue: 43/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        self.challengeNameLabel.text = ChallengeController.sharedController.currentlySelectedChallenge?.name
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {}
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.tableView.reloadData()
        }
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    

    
    //=======================================================
    // MARK: - Tableview datasource functions
    //=======================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetController.participantsTotalsDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell", for: indexPath) as? StandingTableViewCell else { return UITableViewCell() }
        
        let athleteDictionary = SetController.participantsTotalsDictionaries[indexPath.row]
        
        cell.athleteDictionary = athleteDictionary
        
        return cell
    }

}

