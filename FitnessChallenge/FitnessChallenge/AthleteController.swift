//
//  AthleteController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation
import Firebase
import ResearchKit

class AthleteController {
    
    static var currentUserUID: String = ""
    static var currentUser: Athlete?
    
    static var allAthletes: [Athlete] = []
    

    
    
    //CRUD
    
    static func addAthleteToFirebase(username: String, email: String, password: String, uid: String) {
        
        let athlete = Athlete(username: username, email: email, uid: uid)
        currentUser = athlete
        
        let allAthletesRef = ChallengeController.sharedController.baseRef.child("athletes")
        let athleteRef = allAthletesRef.child(athlete.uid)
        
        athleteRef.setValue(athlete.dictionaryRepresentation)
    }
    
    static func loginAthlete(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("There was an error logging in: \(error?.localizedDescription)")
                completion(false)
                return
            } else {
                guard let user = user else { return }
                currentUserUID = user.uid
                fetchCurrentUserFromFirebaseWith(uid: currentUserUID, completion: { 
                    ChallengeController.sharedController.fetchChallenges {
                        completion(true)
                    }
                })
                // Fetch user from firebase here
                print("\(user.uid) has been successfully logged in.")
                
            }
        })
    }
    
    static func fetchAllAthletes(completion: @escaping () -> Void) {
        
        let usersRef = ChallengeController.sharedController.baseRef.child("athletes")
        
        usersRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            guard let valueDictionary = snapshot.value as? [String:[String:Any]] else {
                return
            }
            let athletes = valueDictionary.flatMap({ Athlete(uid: $0.key, dictionary: $0.value) })
            
            AthleteController.allAthletes = athletes
            completion()
        })
    }
    
    static func fetchCurrentUserFromFirebaseWith(uid: String, completion: @escaping () -> Void) {
        
        let currentUserRef = FIRDatabase.database().reference().child("athletes").child(uid)
        
        // Documentation how to fetch user, read data once
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let valueDictionary = snapshot.value as? [String:Any],
                let username = valueDictionary["username"] as? String,
                let email = valueDictionary["email"] as? String
                else { return }
            
                let user = Athlete(uid: uid, dictionary: valueDictionary)
            currentUser = user
            completion()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func logoutAthlete(completion: (Bool) -> Void) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}


