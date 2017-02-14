//
//  PickChallengeTypeViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/8/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class PickChallengeTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var typeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeTableView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
    }
    
    //=======================================================
    // MARK: - Tableview Delegate and DataSource
    //=======================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeController.sharedController.challengeTypeDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "challengeTypeCell", for: indexPath) as? ChallengeTypeTableViewCell else { return UITableViewCell() }
        
        let challengeType = ChallengeController.sharedController.challengeTypeDictionaries[indexPath.row]
        
        cell.setupViews(challengeType: challengeType)
        
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
