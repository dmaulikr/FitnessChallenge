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

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    var tap: UITapGestureRecognizer?
    var googleTap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 47/255, green: 51/255, blue: 55/255, alpha: 1)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        setupFacebookLoginButton()
        setupGoogleLogInButton()
        GIDSignIn.sharedInstance().delegate = self
        
        hideKeyboardWhenViewIsTapped()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != ""
            else { presentMissingInfoAlert(); return }
        
        AthleteController.loginAthlete(email: email, password: password) { (success) in
            if success == true {
                AthleteController.fetchAllAthletes {
                    FriendController.shared.fetchFriendsList {
                        
                        self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                    }
                }
                
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
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
            
            if let error = error {
                print("There was an error with graph request:", error.localizedDescription)
            }
            
            guard let result = result as? [String:String] else { print("There was an error unwrapping result from loggin into facebook"); return }
            
            username = result["name"] ?? ""
            email = result["email"] ?? ""
            
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        self.handleThirdPartyLoginAttempt(credential: credential, fbUserEmail: email, fbUserUsername: username)
    }
    
    //=======================================================
    // MARK: - Google Sign in stuff
    //=======================================================
    
    func setupGoogleLogInButton() {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(signInToGoogle))
        
        googleTap.delegate = self
        googleLoginButton.addGestureRecognizer(googleTap)
        self.googleTap = googleTap
    }
    
    func signInToGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("There was an error signing via Google: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        self.handleThirdPartyLoginAttempt(credential: credential, fbUserEmail: nil, fbUserUsername: nil)
    }
    
    //=======================================================
    // MARK: - Handle 3rd party login
    //=======================================================
    
    func handleThirdPartyLoginAttempt(credential: AuthCredential, fbUserEmail: String?, fbUserUsername: String?) {
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            
            if let error = error {
                print("There was an error signing in the FIR user in the facebook login button: \(error.localizedDescription)")
                self.loginButtonDidLogOut(self.fbLoginButton)
                self.emailAlreadyInUseAlert()
                return
            }
            guard let user = user else { print("Unable to unwrap user in facebook login button"); return }
            
            AthleteController.currentUserUID = user.uid
            AthleteController.fetchCurrentUserFromFirebaseWith(uid: user.uid) { (success) in
                if success {
                    print("\(user.uid) has been successfully logged in.")
                    AthleteController.fetchAllAthletes {
                        FriendController.shared.fetchFriendsList {
                            
                            self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                        }
                    }
                } else {
                    
                    // Create new user
                    print("Didn't segue because unable to fetchCurrentUserFromFirebase. Attemping to addAthleteToFirebase")
                    
                    guard let email = user.email,
                        let username = user.displayName
                    else { return }
                    
                    AthleteController.addAthleteToFirebase(username: username, email: email, uid: user.uid, completion: { (success) in
                        
                        if success {
                            print("New athlete added to Firebase database from a Facebook login")
                            AthleteController.fetchAllAthletes {
                                self.performSegue(withIdentifier: "toChallengesVC", sender: self)
                            }
                        } else {
                            print("Username already taken")
                            self.usernameAlreadyTakenAlert()
//                            self.loginButtonDidLogOut(self.fbLoginButton)
                            AthleteController.logoutAthlete(completion: { (success) in
                                if success {
                                    print("Logged out of Auth")
                                }
                            })
                        }
                    })
                }
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
            // nothing yet
            
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
            
            textField.resignFirstResponder()
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

extension UIViewController {
    func hideKeyboardWhenViewIsTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
