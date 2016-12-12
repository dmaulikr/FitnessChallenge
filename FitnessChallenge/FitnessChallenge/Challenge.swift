//
//  Challenge.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Challenge {

    private let nameKey = "name"
    private let isCompleteKey = "isComplete"
    private let durationKey = "duration"
    private let participantsKey = "participants"
    
    var name: String
    var isComplete: Bool
    var duration: Double
    var participants: [Athlete] = []
    var uid: String
    var creatorId: String
    
    init(name: String, isComplete: Bool, duration: Double, participants: [Athlete] = [], uid: String = UUID().uuidString, creatorId: String) {
    
        self.name = name
        self.isComplete = isComplete
        self.duration = duration
        self.participants = participants
        self.uid = uid
        self.creatorId = creatorId
    }
    
//    init?(uid: String, dictionary: [String:Any]) {
//        
//        
//    }
    
    var dictionaryRepresentation: [String:Any] {
        
        return [nameKey: name, isCompleteKey: isComplete, durationKey: duration, creatorId: creatorId]
    }
}
