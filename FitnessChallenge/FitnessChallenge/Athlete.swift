//
//  Athlete.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Athlete {
    
    var username: String
    var email: String
    var password: String
    var sets: [Set]
    
    init(username: String, email: String, password: String, sets: [Set]) {
        
        self.username = username
        self.email = email
        self.password = password
        self.sets = sets
    }
}

func ==(lhs: Athlete, rhs: Athlete) -> Bool {
    
    return  lhs.username == rhs.username && lhs.email == rhs.email && lhs.password == rhs.password
}

