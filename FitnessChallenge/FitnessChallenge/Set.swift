//
//  Set.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Set {
    
    private let movementTypeKey = "movementType"
    private let repsKey = "reps"
    private let timestampKey = "timestamp"
    private let athleteRefKey = "athleteRef"
    
    var movementType: String
    var reps: Int
    var timestamp: Date
    var uid: String
    var athleteRef: String
    
    init(movementType: String, reps: Int, timestamp: Date, uid: String = UUID().uuidString, athleteRef: String) {
        
        self.movementType = movementType
        self.reps = reps
        self.timestamp = timestamp
        self.uid = uid
        self.athleteRef = athleteRef
    }
    
//    init?(uid: String, dictionary: [String:Any]) {
//        
//        
//    }
    
    var dictionaryRepresentation: [String:Any] {
        
        return [movementTypeKey: movementType, repsKey: reps, timestampKey: timestamp, athleteRefKey: athleteRef]
    }
}

