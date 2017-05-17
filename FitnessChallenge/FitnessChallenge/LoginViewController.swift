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
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 47/255, green: 51/255, blue: 55/255, alpha: 1)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupFacebookLoginButton()
        setupGoogleLogInButton()
        GIDSignIn.sharedInstance().delegate = self
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
        
        fbLoginButton.delegate = self
        
        fbLoginButton.readPermissions = ["email", "public_profile"]
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
                self.loginButtonDidLogOut(self.fbLoginButton)
                self.emailAlreadyInUseAlert()
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
    // MARK: - Google Sign in stuff
    //=======================================================
    
    func setupGoogleLogInButton() {
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("There was an error signing via Google: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if let error = error {
                print("Failed to sign in user with google account: \(error.localizedDescription)")
                return
            }
            
            guard let user = user else { return }
            
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
                
                let email = user.email ?? ""
                let username = user.displayName ?? email
                
                AthleteController.addAthleteToFirebase(username: username, email: email, uid: user.uid, completion: { (success) in
                    
                    if success {
                        print("New athlete added to Firebase database from a Facebook login")
                        self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                    } else {
                        print("Username already taken")
                        self.usernameAlreadyTakenAlert()
                        // signout of google login, signout of firebase auth. present to the user that they cannot use that account. Delete auth user? FIXME
                    }
                })
            }
        })
    }
    
    //=======================================================
    // MARK: - Alert Controllers
    //=======================================================
    
    func presentMissingInfoAlert() {
        
        let alertController = UIAlertController(title: nil, message: "Make sure you enter a username and a password.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func usernameAlreadyTakenAlert() {
        
        let alertController = UIAlertController(title: "Oh no!", message: "Your username is already being used by another login method.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func emailAlreadyInUseAlert() {
        
        let alertController = UIAlertController(title: "Oh no!", message: "Your email is already being used by another login method.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (_) in
//            AthleteController.logoutAthlete(completion: { (success) in
//                // nothing yet
//            })
        }
        
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
