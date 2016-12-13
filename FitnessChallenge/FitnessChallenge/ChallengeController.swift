//
//  ChallengeController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChallengeController {

    
    let baseRef = FIRDatabase.database().reference()
    
    static let sharedController = ChallengeController()
    
    var currentChallenges = [Challenge]()
    var pastChallenges = [Challenge]()
    
    var nonParticipatingFriends = [Athlete]()
    var invitedFriends = [Athlete]()
    var participationFriends = [Athlete]()
    
    
    //CRUD

    // Create challenge and send it to firebase.
    func createChallenge(name: String, isComplete: Bool, creatorId: String) {
        
        let challenge = Challenge(name: name, isComplete: isComplete, creatorId: creatorId)
        currentChallenges.append(challenge)
        
        let allChallenges = baseRef.child("challenges")
        let challengeRef = allChallenges.child(challenge.uid)
        
        challengeRef.setValue(challenge.dictionaryRepresentation)
    }
    
    func endChallenge() {
        
        
    }
    

}

