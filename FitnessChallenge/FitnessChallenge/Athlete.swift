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
    private let challengesKey = "challenges"
    
    var username: String
    var email: String
    var password: String
    var sets: [Set] = []
    var uid: String
    var challenges: [String] = []
    
    init(username: String, email: String, password: String, uid: String = UUID().uuidString) {
        
        self.username = username
        self.email = email
        self.password = password
        self.uid = uid
    }
    
//    init?(uid: String, dictionary: [String:Any]) {
//        
//        
//    }
    
    var dictionaryRepresentation: [String: Any] {
        
        return [usernameKey: username, emailKey: email, passwordKey: password, challengesKey: challenges]
    }
}

//func ==(lhs: Athlete, rhs: Athlete) -> Bool {
//    
//    return  lhs.username == rhs.username && lhs.email == rhs.email && lhs.password == rhs.password
//}

