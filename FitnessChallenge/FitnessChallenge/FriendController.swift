//
//  FriendController.swift
//
//
//  Created by Aaron Martinez on 12/12/16.
//
//

import Foundation
import Firebase

class FriendController {
    
    static let shared = FriendController()
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    var friendRequestsReceived = [String]()
    var currentUserFriendsUids: [String] = []
    var currentUserFriendList: [Athlete] = []
    var invitedFriends = [Athlete]()
    
    static var sentFriendRequestsPending = [String]() // Array of their uids.
    
    enum SendFriendRequestError: Error {
        case alreadyInvited
        case alreadyAFriend
        case noUserWithThatUsername
    }
    
    func fetchFriendsList(completion: @escaping () -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(); return }
        
        let friendsRef = ChallengeController.sharedController.baseRef.child("athletes").child(currentUser.uid).child("friendsUids")
        friendsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let friendsArray = snapshot.value as? [String] else { completion(); return }
            
            self.currentUserFriendsUids = friendsArray
            completion()
        })
    }
    
    func getFriendProfileImages(completion: @escaping () -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(); return }
        let allUsers = AthleteController.allAthletes
        
        let friends = allUsers.filter( {$0.friendsUids.contains(currentUser.uid) } )
        
        var friendsWithImages: [Athlete] = []
        let group = DispatchGroup()
        
        for friend in friends {
            
            group.enter()
            if friend.profileImageUrl != "" {
                
                let downloadedData = Storage.storage().reference(forURL: friend.profileImageUrl)
                downloadedData.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        guard let imageData = data,
                            let image = UIImage(data: imageData) else { completion(); return }
                        friend.profileImage = image
                        friendsWithImages.append(friend)
                        group.leave()
                    }
                    
                }
            } else {
                friendsWithImages.append(friend)
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.currentUserFriendList = friendsWithImages
            completion()
        }
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
    
    static func sendFriendRequest(username: String, completion: @escaping(SendFriendRequestError?) -> Void) {
        
        guard let currentUser = AthleteController.currentUser else { completion(nil); return }
        
        let allAthleteUsernames = AthleteController.allAthletes.flatMap( {$0.username})
        
        guard let uidOfUserToInvite = AthleteController.allAthletes.filter( { $0.username == username } ).first else { print("There was a problem unwrapping first user out of array. \(#function)"); completion(SendFriendRequestError.noUserWithThatUsername); return }
        
        if currentUser.friendRequestsSent.contains(username) {
            // Present Alert saying user has already invited this person.
            completion(SendFriendRequestError.alreadyInvited)
            return
        }
        
        if currentUser.friendsUids.contains(uidOfUserToInvite.uid) {
            // Present Alert saying this user is already your friend.
            completion(SendFriendRequestError.alreadyAFriend)
            return
        }
        
        if allAthleteUsernames.contains(username) {
            
            let athleteRequestedArray = AthleteController.allAthletes.filter({ $0.username == username })
            guard let athleteRequested = athleteRequestedArray.first else { return }
            athleteRequested.friendRequestsReceived.append(currentUser.username)
            currentUser.friendRequestsSent.append(athleteRequested.username)
            
            addFriendRequestToFirebase(athleteRequested: athleteRequested, athleteRequesting: currentUser)
            
            completion(nil)
        } else {
            completion(SendFriendRequestError.noUserWithThatUsername)
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
    
    func acceptFriendRequest(requesterUsername: String,  completion: () -> Void) {
        
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
        
        // Remove Sent Request locally
        let requestSenderArray = allAthletes.filter({$0.username == requesterUsername})
        guard let requestSender = requestSenderArray.first,
            let indexOfReceiverUid = requestSender.friendRequestsSent.index(of: currentUser.username)
            else { completion(); return }
        requestSender.friendRequestsSent.remove(at: indexOfReceiverUid)
        
        // Remove Sent Request from firebase
        let requestSenderRef = baseRef.child(requestSender.uid)
        requestSenderRef.child("friendRequestsSent").setValue(requestSender.friendRequestsSent)
        
        // Add friend to currentUser's friends locally and on firebase
        currentUser.friendsUids.append(requestSender.uid)
        FriendController.shared.currentUserFriendList.append(requestSender)
        requestReceiverRef.child("friendsUids").setValue(currentUser.friendsUids)
        
        // Add current user to sender's friends locally and on firebase
        requestSender.friendsUids.append(currentUser.uid)
        requestSenderRef.child("friendsUids").setValue(requestSender.friendsUids)
        
        completion()
    }
    
    func declineFriendRequest(requesterUsername: String, completion: () -> Void) {
        
        let athletesRef = ChallengeController.sharedController.baseRef.child("athletes")
        guard let currentUser = AthleteController.currentUser else { completion(); return }
        let allAthletes = AthleteController.allAthletes
        
        // Remove Received Friend Request from current User locally
        let array = currentUser.friendRequestsReceived
        guard let indexOfRequest = array.index(of: requesterUsername) else { completion(); return }
        currentUser.friendRequestsReceived.remove(at: indexOfRequest)
        
        // Remove Received Friend Request on firebase
        let requestReceiverRef = athletesRef.child(currentUser.uid)
        requestReceiverRef.child("friendRequestsReceived").setValue(currentUser.friendRequestsReceived)
        
        // Remove Sent Request locally
        let requestSenderArray = allAthletes.filter({$0.username == requesterUsername})
        guard let requestSender = requestSenderArray.first,
            let indexOfReceiverUid = requestSender.friendRequestsSent.index(of: currentUser.username)
            else { completion(); return }
        requestSender.friendRequestsSent.remove(at: indexOfReceiverUid)
        
        // Remove Sent Request from firebase
        let requestSenderRef = athletesRef.child(requestSender.uid)
        requestSenderRef.child("friendRequestsSent").setValue(requestSender.friendRequestsSent)
        
        completion()
    }
    
    func removeFriend() {
        
        
    }
    
    
    
    
}
