//
//  Challenge.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Challenge {
    
    var name: String
    var isComplete: Bool
    var participants: [Athlete:[Set]]
    
    init(name: String, isComplete: Bool, participants: [Athlete:[Set]]) {
    
    self.name = name
    self.isComplete = isComplete
    self.participants = participants
    }
}
