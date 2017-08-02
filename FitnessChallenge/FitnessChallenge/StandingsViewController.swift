//
//  StandingsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class StandingsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var challenge: Challenge?
    var viewIsAlreadyLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        updateChallengeLabel()
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {}
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.tableView.reloadData()
        }
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewIsAlreadyLoaded {
            
            guard let challenge = challenge else { return }
            
            SetController.fetchAllSets(by: challenge.uid) {
                self.tableView.reloadData()
            }
        } else {
            viewIsAlreadyLoaded = true
        }
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    
    
    //=======================================================
    // MARK: - Tableview datasource functions
    //=======================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetController.participantsTotalsDictionariesOrdered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell", for: indexPath) as? StandingTableViewCell else { return UITableViewCell() }
        
        let athleteDictionary = SetController.participantsTotalsDictionariesOrdered[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.indexPath = indexPath
        cell.athleteDictionary = athleteDictionary
        
        return cell
    }
    
    func updateChallengeLabel() {
        
        guard let challengeName = ChallengeController.sharedController.currentlySelectedChallenge?.name
            else { return }
        self.challengeNameLabel.text = "\(challengeName) Leaderboard"
    }
    
}

