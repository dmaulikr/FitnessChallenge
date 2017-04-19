//
//  LoginViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 47/255, green: 51/255, blue: 55/255, alpha: 1)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != ""
            else { presentMissingInfoAlert(); return }
        
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
    
    func presentMissingInfoAlert() {
        
        let alertController = UIAlertController(title: nil, message: "Make sure you enter a username and a password.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
//        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        
        alertController.addAction(okayAction)
//        alertController.addAction(tryAgainAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var boolValue: Bool = false
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:

            if textField.text != "" {
                loginButtonTapped(self)
                boolValue = true
            } else {
                boolValue = false
            }
        default:
            break
        }
        return boolValue
    }
}
