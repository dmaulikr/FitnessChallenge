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
    private let participantsKey = "participants"
    private let creatorIdKey = "creatorId"
    
    var name: String
    var isComplete: Bool
    var participants: [Athlete] = []
    var uid: String
    var creatorId: String
    
    init(name: String, isComplete: Bool, participants: [Athlete] = [], uid: String = UUID().uuidString, creatorId: String) {
    
        self.name = name
        self.isComplete = isComplete
        self.participants = participants
        self.uid = uid
        self.creatorId = creatorId
    }
    
    init?(uid: String, dictionary: [String:Any]) {
        
        guard let name = dictionary[nameKey] as? String,
            let isComplete = dictionary[isCompleteKey] as? Bool,
            let creatorId = dictionary[creatorIdKey] as? String
            else { return nil }
        
        self.name = name
        self.isComplete = isComplete
        self.uid = uid
        self.creatorId = creatorId
        
        
    }
    
    var dictionaryRepresentation: [String:Any] {
        
        return [nameKey: name, isCompleteKey: isComplete, creatorIdKey: creatorId]
    }
}
