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
    
    static var currentUserRef: String = ""
    static var currentUserUID: String = ""
    
    //CRUD
    
    static func addAthleteToFirebase(username: String, email: String, password: String) {
        
        let athlete = Athlete(username: username, email: email, password: password)
        
        let allAthletesRef = ChallengeController.baseRef.child("athletes")
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
                print("\(user.displayName) has been successfully logged in.")
                completion(true)
            }
        })
    }
    
    static func logoutAthlete() {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    


}


