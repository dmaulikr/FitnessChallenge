//
//  LoginViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        ChallengeController.sharedController.fetchChallenges()
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        AthleteController.loginAthlete(email: email, password: password) { (success) in
            if success == true {
                
                
                self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                
            } else {
                let alertController = UIAlertController(title: "Oh no!", message: "We couldn't get you signed in. Please try again.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                
                alertController.addAction(cancelAction)
                alertController.addAction(tryAgainAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
