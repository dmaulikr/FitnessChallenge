//
//  CreateChallengeViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class CreateChallengeViewController: UIViewController {
    
    @IBOutlet weak var challengeNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createChallengeButtonTapped(_ sender: Any) {
        
        guard let challengeName = challengeNameTextField.text,
            let currentUser = AthleteController.currentUser else { return }
        
        ChallengeController.sharedController.createChallenge(name: challengeName, isComplete: false, creatorId: currentUser.uid)
        self.dismiss(animated: true, completion: nil)
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
