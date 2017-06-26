//
//  ChallengeController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChallengeController {
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    static let sharedController = ChallengeController()
    
    let baseRef = Database.database().reference()
    var allChallenges = [Challenge]()
    var currentlySelectedChallenge: Challenge?
    var participatingAthletes = [Athlete]()
    var nonParticipatingFriends = [Athlete]()
    var usersToInviteUids: [String] = [] // Used to hold the UIDs of the athletes to be invited to a new challenge upon challenge creation.
    var userPendingChallengeInvites: [Challenge] = []
    
    var currentChallengePendingInvitees: [Athlete] {
        guard let currentChallenge = currentlySelectedChallenge else { return [] }
        let pendingInviteesUids = currentChallenge.pendingParticipantsUids
        
        var pendingAthletes = [Athlete]()
        for inviteeUid in pendingInviteesUids {
            guard let athlete = AthleteController.allAthletes.filter ({ $0.uid == inviteeUid }).first else { break }
            pendingAthletes.append(athlete)
        }
        
        return pendingAthletes
    }
    
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
    
    /// Static data for PickChallengeTypeViewController's tableView
    
    let challengeTypeDictionaries: [[String:Any]] = [["label":"Push ups" , "image": #imageLiteral(resourceName: "push ups") as UIImage], ["label":"Plank holds", "image": #imageLiteral(resourceName: "plank holds") as UIImage], ["label": "Air squats", "image":#imageLiteral(resourceName: "air squats") as UIImage]]
    
    //CRUD
    
    /// Create challenge and send it to firebase.
    func createChallenge(name: String, isComplete: Bool, endDate: String, creatorUsername: String) {
        
        guard let currentUser = AthleteController.currentUser else { return }
        let challenge = Challenge(name: name, isComplete: isComplete, endDate: endDate, creatorUsername: creatorUsername)
        
        challenge.pendingParticipantsUids = usersToInviteUids
        
        // Add currentUser.uid to the challenge's participantsUids locally
        challenge.participantsUids.append(currentUser.uid)
        
        // Add usersToInviteUids and currentUser.uid to the challenge's participantsUids in firebase
        let allChallenges = baseRef.child("challenges")
        let challengeRef = allChallenges.child(challenge.uid)
        challengeRef.setValue(challenge.dictionaryRepresentation)
        
        currentUser.challenges.append(challenge.uid)
        let userRef = baseRef.child("athletes").child(currentUser.uid).child("challenges")
        userRef.setValue(currentUser.challenges)
        
        usersToInviteUids = []
        self.allChallenges.append(challenge)
        
        NotificationCenter.default.post(name: ChallengeController.sharedController.challengesFetchedNotification, object: nil)
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
    
    func updateCompletedChallenges(completion: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        let challengesToCheckForIsComplete = self.allChallenges.filter( { $0.isComplete == false } )
        
        var challengesToUpdateOnFirebase: [Challenge] = []
        for challenge in challengesToCheckForIsComplete {
            guard let date = dateFormatter.date(from: challenge.endDate) else { completion(); return }
            
            if date < Date() {
                challenge.isComplete = true
                challengesToUpdateOnFirebase.append(challenge)
            }
        }
        let group = DispatchGroup()
        if challengesToUpdateOnFirebase.count > 0 {
            // Save all challenges to Firebase
            for challengeToSave in challengesToUpdateOnFirebase {
                guard let indexOfChallenge = self.allChallenges.index(of: challengeToSave) else { completion(); return }
                self.allChallenges.remove(at: indexOfChallenge)
                self.allChallenges.insert(challengeToSave, at: indexOfChallenge)
                group.enter()
                let challengeRef = baseRef.child("challenges").child(challengeToSave.uid)
                challengeRef.setValue(challengeToSave.dictionaryRepresentation, withCompletionBlock: { (error, _) in
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.main, execute: { 
                completion()
            })
        }
    }
    
    func filterUserPendingChallengeInvites(completion: (Bool) -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(false); return }
        
        userPendingChallengeInvites = allChallenges.filter({ $0.pendingParticipantsUids.contains(currentUser.uid) })
        completion(true)
    }
    
    func toggleAthleteInvitedStatus(selectedAthlete: Athlete, completion: () -> Void) {
        
        if self.usersToInviteUids.contains(selectedAthlete.uid) {
            guard let index = usersToInviteUids.index(of: selectedAthlete.uid) else { return }
            usersToInviteUids.remove(at: index)
            completion()
        } else {
            self.usersToInviteUids.append(selectedAthlete.uid)
            completion()
        }
    }
    
    func filterParticipantsInCurrentChallenge(completion: @escaping() -> Void) {
        
        guard let currentlySelectedChallenge = currentlySelectedChallenge,
            let currentUser = AthleteController.currentUser else { completion(); return }
        
        participatingAthletes = AthleteController.allAthletes.filter({ $0.challenges.contains(currentlySelectedChallenge.uid)})
        let friendsNotCurrentlyParticipating = FriendController.shared.currentUserFriendList.filter( { !$0.challenges.contains(currentlySelectedChallenge.uid) } )
        nonParticipatingFriends = []
        for friend in friendsNotCurrentlyParticipating {
            if !currentlySelectedChallenge.pendingParticipantsUids.contains(friend.uid) {
                nonParticipatingFriends.append(friend)
            }
        }
        
        // Place current user at the start of the order.??
        guard let indexOfCurrentUser = participatingAthletes.index(of: currentUser) else { completion(); return }
        participatingAthletes.remove(at: indexOfCurrentUser)
        participatingAthletes.insert(currentUser, at: 0)
        completion()
    }
    
    func inviteFriendsToChallenge(invitedAthlete: Athlete, completion: () -> Void) {
        
        guard let currentChallenge = self.currentlySelectedChallenge, let index = nonParticipatingFriends.index(of: invitedAthlete) else { completion(); return }
        
        nonParticipatingFriends.remove(at: index)
        
        currentChallenge.pendingParticipantsUids.append(invitedAthlete.uid)
        
        let currentChallengeRef = baseRef.child("challenges").child(currentChallenge.uid)
        currentChallengeRef.child("pendingParticipantsUids").setValue(currentChallenge.pendingParticipantsUids)
        
        completion()
    }
    
    func cancelInvitationToChallenge() {
        
    }
    
    func acceptRequestToJoinChallenge(challenge: Challenge, completion: () -> Void) {
        
        guard let index = userPendingChallengeInvites.index(of: challenge),
            let currentUser = AthleteController.currentUser else { completion(); return }
        userPendingChallengeInvites.remove(at: index)
        
        // Remove Current User uid from challenge.pending... locally
        var currentPendingUids = challenge.pendingParticipantsUids
        guard let index2 = currentPendingUids.index(of: currentUser.uid) else { completion(); return }
        currentPendingUids.remove(at: index2)
        
        // Remove Current User uid from challenge.pending... on firebase
        let challengeRef = baseRef.child("challenges").child(challenge.uid)
        challengeRef.child("pendingParticipantsUids").setValue(currentPendingUids)
        
        // Add currentUser.uid to the selected challenge's participantsUids
        challenge.participantsUids.append(currentUser.uid)
        challengeRef.child("participantsUids").setValue(challenge.participantsUids)
        
        currentUser.challenges.append(challenge.uid)
        let userRef = baseRef.child("athletes").child(currentUser.uid).child("challenges")
        userRef.setValue(currentUser.challenges)
        completion()
    }
    
    func declineRequestToJoinChallenge(challenge: Challenge, completion: () -> Void) {
        
        // Remove challenge from local "userPendingChallengeInvites"
        guard let index = userPendingChallengeInvites.index(of: challenge),
            let currentUser = AthleteController.currentUser else { completion(); return }
        userPendingChallengeInvites.remove(at: index)
        
        // Remove user's uid from challenge's pendingParticipantsUids locally
        var currentPendingUids = challenge.pendingParticipantsUids
        guard let index2 = currentPendingUids.index(of: currentUser.uid) else { completion(); return }
        currentPendingUids.remove(at: index2)
        
        let challengeRef = baseRef.child("challenges").child(challenge.uid)
        challengeRef.child("pendingParticipantsUids").setValue(currentPendingUids)
        
        completion()
    }
    
    ///=======================================================
    // MARK: - Notifications
    //=======================================================
    
    var currentPageIndexNotification = Notification.Name("currentPageIndex")
    var currentSegmentNotification = Notification.Name("currentSegment")
    var challengesFetchedNotification = Notification.Name("challengesFetched")
    
}
