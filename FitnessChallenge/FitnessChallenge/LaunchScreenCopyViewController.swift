//
//  LaunchScreenCopyViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/29/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenCopyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AthleteController.fetchAllAthletes {
        //
        //        }
        performLaunchChecks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func performLaunchChecks() {
        
        if InternetConnection.isInternetAvailable() == false {
            
            let internetAlert = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginScreen") as UIViewController
                self.present(loginVC, animated: true, completion: nil)
            })
            
            internetAlert.addAction(okAction)
            present(internetAlert, animated: true, completion: nil)
            
        } else {
            
            if Auth.auth().currentUser != nil {
                guard let currentUser = Auth.auth().currentUser
                    else { return }
                let uid = currentUser.uid
                
                AthleteController.fetchCurrentUserFromFirebaseWith(uid: uid) { (success) in
                    if success == true {
                        
                        AthleteController.fetchAllAthletes {
                            FriendController.shared.fetchFriendsList {
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
                                
                                self.present(navigationVC, animated: true, completion: nil)
                            }
                        }
                    } else {
                        
                        AthleteController.logoutAthlete(completion: { (_) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen") as UIViewController
                            self.present(loginVC, animated: true, completion: nil)
                        })
                        
                    }
                }
            } else {
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginScreen") as UIViewController
                DispatchQueue.main.async { 
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
}
