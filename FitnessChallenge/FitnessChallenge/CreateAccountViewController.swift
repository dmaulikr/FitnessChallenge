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
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
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
            AthleteController.addAthleteToFirebase(username: username, email: email, password: password, uid: user.uid, completion: { (success) in
                
                if !success {
                    
                    self.usernameAlreadyTakenAlert(email: email, password: password, uid: user.uid)
                    
                } else {
                    
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
                    
                }
                
            })
            
        })
    }
    
    
    //=======================================================
    // MARK: - Helper functions
    //=======================================================
    
    func usernameAlreadyTakenAlert(email: String, password: String, uid: String) {
        
        let alertController = UIAlertController(title: "Username already taken", message: nil, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        var usernameTextfield: UITextField?
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "New username"
            usernameTextfield = textfield
        }
        let submitAction = UIAlertAction(title: "Try Again", style: .default) { (_) in
            
            guard let newUsername = usernameTextfield?.text else { return }
            AthleteController.addAthleteToFirebase(username: newUsername, email: email, password: password, uid: uid, completion: { (success) in
                
                if !success {
                    
                    self.usernameAlreadyTakenAlert(email: email, password: password, uid: uid)
                    
                } else {
                    
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
                    
                }
            })
        }
        
        
//        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
