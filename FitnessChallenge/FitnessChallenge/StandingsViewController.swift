//
//  StandingsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import ResearchKit

class StandingsViewController: UIViewController {
    
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentUserSets: [ORKValueStack] = []
    
    var challenge: Challenge?
    
    let chartColors = [
        UIColor(red: 225/255, green: 90/255, blue: 43/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.challengeNameLabel.text = ChallengeController.sharedController.currentlySelectedChallenge?.name
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {}
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
//        self.setupBarGraphChartView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
//            self.graphView.reloadData()
        }
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    

    
    //=======================================================
    // MARK: - Tableview datasource functions
    //=======================================================
    


}

