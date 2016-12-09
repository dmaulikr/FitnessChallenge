//
//  Set.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Set {
    
    var movementType: String
    var reps: Int
    var timestamp: Date
    
    init(movementType: String, reps: Int, timestamp: Date) {
        
        self.movementType = movementType
        self.reps = reps
        self.timestamp = timestamp
    }
}

