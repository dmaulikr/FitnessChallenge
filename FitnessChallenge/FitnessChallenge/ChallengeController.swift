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

    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    static let sharedController = ChallengeController()
    
    let baseRef = FIRDatabase.database().reference()
    var allChallenges = [Challenge]()
    var currentlySelectedChallenge: Challenge?
    
    var userChallengeInvites: [Challenge] = []
    
    var userCurrentChallenges: [Challenge] {
        
        guard let currentUser = AthleteController.currentUser
            else { return [] }
        
        let activeChallenges = allChallenges.filter({ $0.isComplete == false })
        
        // This will need to change to populate any challenge the current user is tied to.
        return activeChallenges.filter({ $0.creatorUsername == currentUser.username })
    }
    
    var userPastChallenges: [Challenge] {
        
        guard let currentUser = AthleteController.currentUser
            else { return [] }
        
        let allPastChallenges = allChallenges.filter({ $0.isComplete == true })
        
        return allPastChallenges.filter({ $0.creatorUsername == currentUser.username})
    }
    
    
    
    //CRUD

    // Create challenge and send it to firebase.
    func createChallenge(name: String, isComplete: Bool, endDate: Date, creatorUsername: String) {
        
        let challenge = Challenge(name: name, isComplete: isComplete, endDate: endDate, creatorUsername: creatorUsername)
        self.allChallenges.append(challenge)
        
        let allChallenges = baseRef.child("challenges")
        let challengeRef = allChallenges.child(challenge.uid)
        
        challengeRef.setValue(challenge.dictionaryRepresentation)
    }
    
    func endChallenge(challenge: Challenge) {
        
        challenge.isComplete = !challenge.isComplete
    }
    
    func fetchChallenges(completion: @escaping () -> Void) {
    
        let allChallengesRef = baseRef.child("challenges")
        allChallengesRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let challengesDictionary = snapshot.value as? [String : [String: Any]]
            
            guard let challenges = challengesDictionary?.flatMap({Challenge(uid: $0.key, dictionary: $0.value)}) else { return }

            ChallengeController.sharedController.allChallenges = challenges
            completion()
        })
    }
    
    func filterChallengesByCurrentUserInvites() {
        
        guard let currentUser = AthleteController.currentUser else { return }
        
        userChallengeInvites = allChallenges.filter({$0.pendingParticipantsUids.contains(currentUser.uid)})
        let challengePendingParticipantsUidsRef = baseRef.child("challenges").child(currentUser.uid).child("pendingParticipantsUids")
//        challengePendingParticipantsUidsRef.setValue(

    }
    
    func inviteFriendsToChallenge() {
        
    }
    
    func cancelInvitationToChallenge() {
        
    }
    
    func acceptRequestToJoinChallenge() {
        
        
    }
    
    func declineRequestToJoinChallenge() {
        
        
    }
}

