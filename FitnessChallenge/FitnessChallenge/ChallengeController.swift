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
    
    static let baseRef = FIRDatabase.database().reference()
    
    static let sharedController = ChallengeController()
    
    var currentChallenges = [Challenge]()
    var pastChallenges = [Challenge]()
    
    //CRUD

//    func createChallenge() {
//        
//        let challenge = Challenge(name: <#T##String#>, isComplete: <#T##Bool#>, duration: <#T##Double#>, creatorId: <#T##String#>)
//    }

    
    
    func sendChallengeToFirebase() {
        
//        let challenge = Challenge(name: "Test", isComplete: false, startDate: Date(), duration: 3600)
//        
//        let allChallengesRef = baseRef.child("challenges")
//        
//        let testChallengeRef = allChallengesRef.child(challenge.uid)
//        
//        testChallengeRef.setValue(challenge.dictionaryRepresentation)
        
    }
    
    func endChallenge() {
        
        
    }
    
    func inviteFriends() {
        
    }
    
    func cancelInvitation() {
        
    }
    
    func acceptRequestToJoin() {
        
        
    }
}

