//
//  CreateAccountViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccountButton.layer.cornerRadius = 5
        
        self.hideKeyboardWhenViewIsTapped()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
        email != "",
        let username = usernameTextField.text,
        username != "",
        let password = passwordTextField.text,
        password != ""
            else { presentEmptyTextfieldsAlert(); return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print("There was an error creating new user: \(error.localizedDescription)")
                return
            }
            guard let user = user else { return }
            AthleteController.addAthleteToFirebase(username: username, email: email, uid: user.uid, completion: { (success) in
                
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
    // MARK: - Textfield delegate
    //=======================================================
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            createAccountButtonTapped(self)
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    //=======================================================
    // MARK: - Alerts
    //=======================================================
    
    func presentEmptyTextfieldsAlert() {
        
        let alertController = UIAlertController(title: nil, message: "*All fields are required", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
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
            AthleteController.addAthleteToFirebase(username: newUsername, email: email, uid: uid, completion: { (success) in
                
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

extension UIViewController {
    func hideKeyboardWhenViewIsTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}



