//
//  LoginViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 47/255, green: 51/255, blue: 55/255, alpha: 1)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupFacebookLoginButton()
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
    
    //=======================================================
    // MARK: - Facebook login stuff
    //=======================================================
    
    func setupFacebookLoginButton() {
        
        
        
        
//        self.view.addSubview(facebookLoginButton)
        fbLoginButton.delegate = self
        
        fbLoginButton.readPermissions = ["email", "public_profile"]
        
//        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        let top = NSLayoutConstraint(item: facebookLoginButton, attribute: .top, relatedBy: .equal, toItem: self.loginButton, attribute: .bottom, multiplier: 1, constant: 12)
//        let leading = NSLayoutConstraint(item: facebookLoginButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: 0)
//        let trailing = NSLayoutConstraint(item: facebookLoginButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 0)
//        
//        self.view.addConstraints([top, leading, trailing])
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        var username: String = ""
        var email: String = ""
        
        if error != nil {
            print("There was an error logging in with Facebook", error)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
            
            if let error = error {
                print("There was an error with graph request:", error.localizedDescription)
            }
            
            guard let result = result as? [String:String] else { print("There was an error unwrapping result from loggin into facebook"); return }
            
            username = result["name"] ?? ""
            email = result["email"] ?? ""
            
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if let error = error {
                print("There was an error signing in the FIR user in the facebook login button: \(error.localizedDescription)")
                return
            }
            guard let user = user else { print("Unable to unwrap user in facebook login button"); return }
            
            let allAthletesUids = AthleteController.allAthletes.flatMap( { $0.uid } )
            
            if allAthletesUids.contains(user.uid) {
                
                AthleteController.currentUserUID = user.uid
                AthleteController.fetchCurrentUserFromFirebaseWith(uid: user.uid) { (success) in
                    if success {
                        print("\(user.uid) has been successfully logged in.")
                        self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                    } else {
                        print("Didn't segue because unable to fetchCurrentUserFromFirebase")
                        return
                    }
                }
            } else {
                
                AthleteController.addAthleteToFirebase(username: username, email: email, uid: user.uid, completion: { (success) in
                    
                    if success {
                        print("New athlete added to Firebase database from a Facebook login")
                        self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                    } else {
                        // Alert controller telling the user their username is already taken. Not for long, fix this.
                        print("Username already taken")
                        // signout of facebook login, signout of firebase auth. present to the user that they cannot use that account. Delete auth user? FIXME
                    }
                })
            }
            
        })
        

    }
    
    //=======================================================
    // MARK: - Missing info Alert Controller
    //=======================================================
    
    func presentMissingInfoAlert() {
        
        let alertController = UIAlertController(title: nil, message: "Make sure you enter a username and a password.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //=======================================================
    // MARK: - UITextfieldelegate functions
    //=======================================================
    
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
