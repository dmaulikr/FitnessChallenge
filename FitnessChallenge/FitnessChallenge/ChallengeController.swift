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
    var participatingFriends = [Athlete]()
    var pendingUsersUids: [String] = [] // Used to hold the UIDs of the athletes to be invited to a new challenge. (Because a challenge with a "pendingParticipantsUids" dosen't exist yet.
    
    var userPendingChallengeInvites: [Challenge] = []
    
    var userCurrentChallenges: [Challenge] {
        
        guard let currentUser = AthleteController.currentUser
            else { return [] }
        
        let activeChallenges = allChallenges.filter({ $0.isComplete == false })
        
        var userChallenges: [Challenge] = []
        for challenge in activeChallenges {
            
            if challenge.participantsUids.contains(currentUser.uid) || challenge.creatorUsername == currentUser.username {
                userChallenges.append(challenge)
            }
        }
        return userChallenges
    }
    
    var userPastChallenges: [Challenge] {
        
        guard let currentUser = AthleteController.currentUser
            else { return [] }
        
        let allPastChallenges = allChallenges.filter({ $0.isComplete == true })
        
        var pastChallenges: [Challenge] = []
        for challenge in allPastChallenges {
            
            if challenge.participantsUids.contains(currentUser.uid) || challenge.creatorUsername == currentUser.username {
                pastChallenges.append(challenge)
            }
        }
        
        return pastChallenges
    }
    
    
    
    //CRUD

    // Create challenge and send it to firebase.
    func createChallenge(name: String, isComplete: Bool, endDate: String, creatorUsername: String) {
        
        guard let currentUser = AthleteController.currentUser else { return }
        let challenge = Challenge(name: name, isComplete: isComplete, endDate: endDate, creatorUsername: creatorUsername)
        
        challenge.pendingParticipantsUids = pendingUsersUids
        
        // Add currentUser.uid to the challenge's participantsUids locally
        challenge.participantsUids.append(currentUser.uid)
        
        // Add currentUser.uid to the challenge's participantsUids in firebase
        let allChallenges = baseRef.child("challenges")
        let challengeRef = allChallenges.child(challenge.uid)
        challengeRef.setValue(challenge.dictionaryRepresentation)
        
        // TODO: - Does this update the current user everywhere in the app?
        currentUser.challenges.append(challenge.uid)
        let userRef = baseRef.child("athletes").child(currentUser.uid).child("challenges")
        userRef.setValue(currentUser.challenges)
        
        pendingUsersUids = []
        self.allChallenges.append(challenge)
        // TODO: - We the functions that get data from allChallenges need to be run again in order to get this new challenge and it's details?
    }
    
    func endChallenge(challenge: Challenge) {
        
        challenge.isComplete = !challenge.isComplete
    }
    
    func fetchChallenges(completion: @escaping () -> Void) {
    
        let allChallengesRef = baseRef.child("challenges")
        allChallengesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let challengesDictionary = snapshot.value as? [String : [String: Any]]
            
            guard let challenges = challengesDictionary?.flatMap({Challenge(uid: $0.key, dictionary: $0.value)}) else { completion(); return }

            ChallengeController.sharedController.allChallenges = challenges
            completion()
        })
    }
    
    func filterUserPendingChallengeInvites() {
        
        guard let currentUser = AthleteController.currentUser else { return }
        
        userPendingChallengeInvites = allChallenges.filter({ $0.pendingParticipantsUids.contains(currentUser.uid) })
//        let challengePendingParticipantsUidsRef = baseRef.child("challenges").child(currentUser.uid).child("pendingParticipantsUids")
//        challengePendingParticipantsUidsRef.setValue(

    }
    
    func toggleAthleteInvitedStatus(selectedAthlete: Athlete, completion: () -> Void) {
        
        if self.pendingUsersUids.contains(selectedAthlete.uid) {
            guard let index = pendingUsersUids.index(of: selectedAthlete.uid) else { return }
            pendingUsersUids.remove(at: index)
            completion()
        } else {
            self.pendingUsersUids.append(selectedAthlete.uid)
            completion()
        }
    }
    
    func filterParticipantsInCurrentChallenge() {
        
        guard let currentlySelectedChallenge = currentlySelectedChallenge else { return }
        
        participatingFriends = AthleteController.allAthletes.filter({ $0.challenges.contains(currentlySelectedChallenge.uid)})
    }
    

    
    func inviteFriendsToChallenge() {
        
    }
    
    func cancelInvitationToChallenge() {
        
    }
    
    func acceptRequestToJoinChallenge(challenge: Challenge, completion: () -> Void) {
        
        guard let index = userPendingChallengeInvites.index(of: challenge),
            let currentUser = AthleteController.currentUser else { completion(); return }
        userPendingChallengeInvites.remove(at: index)
        
        // Remove Current User uid from chellenge.pending... locally
        var currentPendingUids = challenge.pendingParticipantsUids
        guard let index2 = currentPendingUids.index(of: currentUser.uid) else { completion(); return }
        currentPendingUids.remove(at: index2)
        
        // Remove Current User uid from chellenge.pending... on firebase
        let challengeRef = baseRef.child("challenges").child(challenge.uid)
        challengeRef.child("pendingParticipantsUids").setValue(currentPendingUids)
        
        // Add currentUser.uid to the selected challenge's participantsUids
        challenge.participantsUids.append(currentUser.uid)
//        currentParticipantsUids.append(currentUser.uid)
        challengeRef.child("participantsUids").setValue(challenge.participantsUids)
        
        currentUser.challenges.append(challenge.uid)
        let userRef = baseRef.child("athletes").child(currentUser.uid).child("challenges")
        userRef.setValue(currentUser.challenges)
        completion()
    }
    
    func declineRequestToJoinChallenge() {
        
        
    }
}

