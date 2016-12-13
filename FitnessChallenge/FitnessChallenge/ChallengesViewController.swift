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
        
        self.currentChallengesTableView.delegate = self
        self.currentChallengesTableView.dataSource = self

        guard let username = AthleteController.currentUser?.username else { return }
            self.welcomeLabel.text = "Welcome \(username)!"
    }

    // Current Challenges TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeController.sharedController.currentChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentChallengeCell", for: indexPath)
        
        let challenge = ChallengeController.sharedController.currentChallenges[indexPath.row]
        
        cell.textLabel?.text = challenge.name
        cell.detailTextLabel?.text = challenge.creatorId
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
