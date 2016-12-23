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
    private let uidKey = "uid"
    
    var movementType: String
    var reps: Int
    var timestamp: Date
    var uid: String
    var athleteRef: String
    
    init(movementType: String, reps: Int, timestamp: Date = Date(), uid: String = UUID().uuidString, athleteRef: String) {
        
        self.movementType = movementType
        self.reps = reps
        self.timestamp = timestamp
        self.uid = uid
        self.athleteRef = athleteRef
    }
    
    init?(uid: String, dictionary: [String:Any]) {
        
        guard let movementType = dictionary[movementTypeKey] as? String,
            let reps = dictionary[repsKey] as? Int,
            let timeInterval = dictionary[timestampKey] as? TimeInterval,
            let uid = dictionary[uidKey] as? String,
            let athleteRef = dictionary[athleteRefKey] as? String else {
            return nil
        }
        let timestamp = Date(timeIntervalSince1970: timeInterval)
        
        self.movementType = movementType
        self.reps = reps
        self.timestamp = timestamp
        self.uid = uid
        self.athleteRef = athleteRef
        
        
    }
    
    var dictionaryRepresentation: [String:Any] {
        
        let dateInterval = timestamp.timeIntervalSince1970
        
        return [movementTypeKey: movementType, repsKey: reps, timestampKey: dateInterval, athleteRefKey: athleteRef, uidKey: uid]
    }
}

