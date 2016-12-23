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
    private let passwordKey = "password"
    private let uidKey = "uid"
    private let challengesKey = "challenges"
    
    var username: String
    var email: String
    var password: String
    
    var sets: [Set] = []
    var uid: String
    var challenges: [String] = []
    
    init(username: String, email: String, password: String, uid: String) {
        
        self.username = username
        self.email = email
        self.password = password
        self.uid = uid
    }
    
    init?(uid: String, dictionary: [String:Any]) {
        
        guard let username = dictionary[usernameKey] as? String,
            let email = dictionary[emailKey] as? String,
            let password = dictionary[passwordKey] as? String,
            let uid = dictionary[uidKey] as? String,
            let challenges = dictionary[challengesKey] as? [String] else {
                return nil
        }
        
        self.username = username
        self.email = email
        self.password = password
        self.uid = uid
        self.challenges = challenges
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        return [usernameKey: username, emailKey: email, passwordKey: password, uidKey: uid, challengesKey: challenges]
    }
}


