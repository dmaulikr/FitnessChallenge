//
//  FriendController.swift
//  
//
//  Created by Aaron Martinez on 12/12/16.
//
//

import Foundation

class FriendController {
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
//    static var currentUserFriendList: [Athlete] {
//        
//        guard let currentUser = AthleteController.currentUser else {
//                return []
//        }
//        let allUsers = AthleteController.allAthletes
//        
//        let currentUserFriends = allUsers.filter( { } )
//        
//    }
    
    var nonParticipatingFriends = [Athlete]()
    var invitedFriends = [Athlete]()
    var participatingFriends = [Athlete]()
    
    static var sentFriendRequestsPending = [String]() // Array of their uids.
    
    
    
    func fetchFriendsList() {
        
        
    }
    
    func fetchFriendRequests() {
        
        
    }
    
    static func sendFriendRequest(username: String, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(false); return }
        
        let allAthleteUsernames = AthleteController.allAthletes.flatMap( {$0.username})
        
        if allAthleteUsernames.contains(username) {
            
            let athleteRequestedArray = AthleteController.allAthletes.filter({ $0.username == username })
            guard let athleteRequested = athleteRequestedArray.first else { return }
            athleteRequested.friendRequestsReceived.append(currentUser.username)
            
            addFriendRequestToFirebase(athlete: athleteRequested)
//            sentFriendRequestsPending.append(username)
            
            
            completion(true)
        } else {
            completion(false)
        }
        
    }
    
    static func addFriendRequestToFirebase(athlete: Athlete) {
        
        let baseRef = ChallengeController.sharedController.baseRef
        let athletesRef = baseRef.child("athletes").child(athlete.uid).child("friendRequestsReceived")
        athletesRef.setValue(athlete.friendRequestsReceived)
        
        
        
    }
    
    func acceptFriendRequest() {
        
        
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
