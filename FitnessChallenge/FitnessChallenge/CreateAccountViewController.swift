//
//  CreateAccountViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text
            else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("There was an error creating new user: \(error?.localizedDescription)")
                return
            }
            guard let user = user else { return }
            AthleteController.addAthleteToFirebase(username: username, email: email, password: password, uid: user.uid)
            AthleteController.loginAthlete(email: email, password: password, completion: { (success) in
                if success == true {
                    self.performSegue(withIdentifier: "toChallengesView", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Oh no!", message: "We couldn't get you signed in. Please try again.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(tryAgainAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
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
