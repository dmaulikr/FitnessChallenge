//
//  AthleteController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation
import Firebase

class AthleteController {
    
//    static var currentUserRef: String = ""
    static var currentUserUID: String = ""
    static var currentUser: Athlete?
    
    //CRUD
    
    static func addAthleteToFirebase(username: String, email: String, password: String, uid: String) {
        
        let athlete = Athlete(username: username, email: email, password: password, uid: uid)
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
    
    static func fetchCurrentUserFromFirebaseWith(uid: String, completion: @escaping () -> Void) {
        
        let currentUserRef = FIRDatabase.database().reference().child("athletes").child(uid)
        
        // Documentation how to fetch user, read data once
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let valueDictionary = snapshot.value as? [String:Any],
                let username = valueDictionary["username"] as? String,
                let email = valueDictionary["email"] as? String,
                let password = valueDictionary["password"] as? String
                else { return }
            
            let user = Athlete(username: username, email: email, password: password, uid: uid)
            currentUser = user
            completion()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func logoutAthlete() {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func addSet(selectedReps: Int) {
        
        guard let user = AthleteController.currentUser,
            let challenge = ChallengeController.sharedController.currentlySelectedChallenge else { return }
        
        
        
        let set = Set(movementType: challenge.movementType, reps: selectedReps, athleteRef: user.uid)
        
        let allSets = ChallengeController.sharedController.baseRef.child("sets")
        let setRef = allSets.child(set.uid)
        
        setRef.setValue(set.dictionaryRepresentation)
    }
    
    


}


