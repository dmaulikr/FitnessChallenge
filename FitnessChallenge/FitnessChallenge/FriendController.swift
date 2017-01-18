//
//  FriendController.swift
//  
//
//  Created by Aaron Martinez on 12/12/16.
//
//

import Foundation

class FriendController {
    
    static let shared = FriendController()
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    var currentUserFriendList: [Athlete] {
        
        guard let currentUser = AthleteController.currentUser else {
                return []
        }
        let allUsers = AthleteController.allAthletes
        
        return allUsers.filter( {$0.friendsUids.contains(currentUser.uid) } )
        
    }
    
    var currentUserFriendsUids: [String] = []
    var friendRequestsReceived = [String]()
    var nonParticipatingFriends = [Athlete]()
    var invitedFriends = [Athlete]()
    var participatingFriends = [Athlete]()
    
    static var sentFriendRequestsPending = [String]() // Array of their uids.
    
    
    
    func fetchFriendsList() {
        
        guard let currentUser = AthleteController.currentUser else { return }
        
        let friendsRef = ChallengeController.sharedController.baseRef.child("athletes").child(currentUser.uid).child("friendsUids")
        friendsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let friendsArray = snapshot.value as? [String] else { return }
            
            self.currentUserFriendsUids = friendsArray
        })
    }
    
    func fetchFriendRequestsReceived() {
        
        guard let currentUser = AthleteController.currentUser else { return }
        let currentUserRef = ChallengeController.sharedController.baseRef.child("athletes").child(currentUser.uid).child("friendRequestsReceived")
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let friendRequestsReceivedArray = snapshot.value as? [String] else { print("FriendController: Could not get value at friendRequestsReceived"); return }
            
            self.friendRequestsReceived = friendRequestsReceivedArray
            currentUser.friendRequestsReceived = friendRequestsReceivedArray
        })
        
        
    }
    
    static func sendFriendRequest(username: String, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(false); return }
        
        let allAthleteUsernames = AthleteController.allAthletes.flatMap( {$0.username})
        
        if allAthleteUsernames.contains(username) {
            
            let athleteRequestedArray = AthleteController.allAthletes.filter({ $0.username == username })
            guard let athleteRequested = athleteRequestedArray.first else { return }
            athleteRequested.friendRequestsReceived.append(currentUser.username)
            currentUser.friendRequestsSent.append(athleteRequested.username)
            
            addFriendRequestToFirebase(athleteRequested: athleteRequested, athleteRequesting: currentUser)
//            sentFriendRequestsPending.append(username)
            
            
            completion(true)
        } else {
            completion(false)
        }
        
    }
    
    static func addFriendRequestToFirebase(athleteRequested: Athlete, athleteRequesting: Athlete) {
        
        // Add requesters username to the requested's friendRequestsReceived
        let baseRef = ChallengeController.sharedController.baseRef
        let requestedsRef = baseRef.child("athletes").child(athleteRequested.uid).child("friendRequestsReceived")
        requestedsRef.setValue(athleteRequested.friendRequestsReceived)
        
        // Add the requested's username to the requester's friend requests sent.
        
        let requestersRef = baseRef.child("athletes").child(athleteRequesting.uid).child("friendRequestsSent")
        requestersRef.setValue(athleteRequesting.friendRequestsSent)
        
    }
    
    func acceptFriendRequest(requesterUsername: String, completion: () -> Void) {
        
        let baseRef = ChallengeController.sharedController.baseRef.child("athletes")
        guard let currentUser = AthleteController.currentUser else { completion(); return }
        let allAthletes = AthleteController.allAthletes
        
        // Remove Received Friend Request locally
        let array = currentUser.friendRequestsReceived
        guard let indexOfRequest = array.index(of: requesterUsername) else { completion(); return }
        currentUser.friendRequestsReceived.remove(at: indexOfRequest)
        // Remove Received Friend Request on firebase
        let requestReceiverRef = baseRef.child(currentUser.uid)
        requestReceiverRef.child("friendRequestsReceived").setValue(currentUser.friendRequestsReceived)
        
        // Remove Sent Request from firebase
        let requestSenderArray = allAthletes.filter({$0.username == requesterUsername})
        guard let requestSender = requestSenderArray.first,
            let indexOfReceiverUid = requestSender.friendRequestsSent.index(of: currentUser.username) else { completion(); return }
        requestSender.friendRequestsSent.remove(at: indexOfReceiverUid)
        let requestSenderRef = baseRef.child(requestSender.uid)
        requestSenderRef.child("friendRequestsSent").setValue(requestSender.friendRequestsSent)
        
        // Add friend to currentUser's friends locally and on firebase
        currentUser.friendsUids.append(requestSender.uid)
        requestReceiverRef.child("friendsUids").setValue(currentUser.friendsUids)
        
        // Add friend to sender's friends on firebase
        requestSender.friendsUids.append(currentUser.uid)
        requestSenderRef.child("friendsUids").setValue(requestSender.friendsUids)
        
        completion()
    }
    
    func declineFriendRequest() {
        
        
    }
    
    func removeFriend() {
        
        
    }
    
    func inviteFriendsToChallenge() {
        
    }
    
    func cancelInvitation() {
        
    }
    
    func acceptRequestToJoinChallenge() {
        
        
    }
    
    func declineRequestToJoinChallenge() {
        
        
    }
    
    
}
