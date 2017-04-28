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
    static let storageRef = FIRStorage.storage().reference()
    static var usernamesUsed: [String] = []

    
    //CRUD
    
    static func addAthleteToFirebase(username: String, email: String, uid: String, completion: @escaping(_ success: Bool) -> Void) {
        
        let baseRef = ChallengeController.sharedController.baseRef
        let usernamesUsedRef = baseRef.child("usernamesUsed")
        usernamesUsedRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let usernamesUsedArray = snapshot.value as? [String] else { completion(false); return }
            
            usernamesUsed = usernamesUsedArray
            
            if usernamesUsed.contains(username) {
                
                completion(false)
                
            } else {
                
                let athlete = Athlete(username: username, email: email, uid: uid)
                currentUser = athlete
                
                let allAthletesRef = ChallengeController.sharedController.baseRef.child("athletes")
                let athleteRef = allAthletesRef.child(athlete.uid)
                athleteRef.setValue(athlete.dictionaryRepresentation)
                
                usernamesUsed.append(username)
                usernamesUsedRef.setValue(usernamesUsed)
                
                completion(true)
            }
            
        })
        
    }
    
    static func loginAthlete(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print("There was an error logging in: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                guard let user = user else { completion(false); return }
                currentUserUID = user.uid
                fetchCurrentUserFromFirebaseWith(uid: currentUserUID) { (success) in
                    if success {
                        print("\(user.uid) has been successfully logged in.")
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        })
    }
    
    static func fetchAllAthletes(completion: @escaping () -> Void) {
        
        let usersRef = ChallengeController.sharedController.baseRef.child("athletes")
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let valueDictionary = snapshot.value as? [String:[String:Any]] else { completion()
                return
            }
            let athletes = valueDictionary.flatMap({ Athlete(uid: $0.key, dictionary: $0.value) })
            
            AthleteController.allAthletes = athletes
            completion()
        })
    }
    
    static func fetchCurrentUserFromFirebaseWith(uid: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let currentUserRef = FIRDatabase.database().reference().child("athletes").child(uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let valueDictionary = snapshot.value as? [String:Any]
                else { completion(false); return }
            
                let user = Athlete(uid: uid, dictionary: valueDictionary)
            currentUser = user
            completion(true)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
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
    
    static func saveProfilePhotoToFirebase(image: UIImage) {
        
        guard let currentUser = currentUser,
            let imageData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        storageRef.child(currentUser.username).put(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("AthleteController: There was an error saving profile photo to firebase")
            } else {
                guard let downloadedImageURL = metadata?.downloadURL()?.absoluteString else { return }
                
                currentUser.profileImageUrl = downloadedImageURL
                
                let athleteRef = ChallengeController.sharedController.baseRef.child("athletes").child(currentUser.uid).child("profileImageUrl")
                athleteRef.setValue(downloadedImageURL)
            }
        }
        
    }
    
    static func loadImageFromData(url: String) {
        
        let downloadedData = FIRStorage.storage().reference(forURL: url)
        downloadedData.data(withMaxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let imageData = data,
                    let image = UIImage(data: imageData) else { return }
                currentUser?.profileImage = image
            }
            
        }
    }
}


