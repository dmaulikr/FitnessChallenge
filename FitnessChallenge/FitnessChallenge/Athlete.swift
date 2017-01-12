//
//  Athlete.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Athlete {
    
    private let usernameKey = "username"
    private let emailKey = "email"
    private let uidKey = "uid"
    private let challengesKey = "challenges"
    private let friendsUidsKey = "friendsUids"
    private let friendRequestsReceivedKey = "friendRequestsReceived"
    private let friendRequestsSentKey = "friendRequestsSent"
    
    var username: String
    var email: String
    var sets: [Set] = []
    var uid: String
    var challenges: [String] = []
    var friendsUids: [String] = []
    var friendRequestsReceived: [String] = []
    var friendRequestsSent: [String] = []
    
    init(username: String, email: String, uid: String) {
        
        self.username = username
        self.email = email
        self.uid = uid
    }
    
    init?(uid: String, dictionary: [String:Any]) {
        
        guard let username = dictionary[usernameKey] as? String,
            let email = dictionary[emailKey] as? String,
            let uid = dictionary[uidKey] as? String else {
                return nil
        }
        
        let challenges = dictionary[challengesKey] as? [String]
        let friendsUids = dictionary[friendsUidsKey] as? [String]
        let friendRequestsReceived = dictionary[friendRequestsReceivedKey] as? [String]
        let friendRequestsSent = dictionary[friendRequestsSentKey] as? [String]
        
        self.username = username
        self.email = email
        self.uid = uid
        self.challenges = challenges ?? []
        self.friendsUids = friendsUids ?? []
        self.friendRequestsReceived = friendRequestsReceived ?? []
        self.friendRequestsSent = friendRequestsSent ?? []
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        return [usernameKey: username, emailKey: email, uidKey: uid, challengesKey: challenges, friendsUidsKey: friendsUids, friendRequestsReceivedKey: friendRequestsReceived, friendRequestsSentKey: friendRequestsSent]
    }
}


