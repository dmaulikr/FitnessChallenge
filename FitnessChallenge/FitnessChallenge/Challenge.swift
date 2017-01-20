//
//  Challenge.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class Challenge: Equatable {

    private let nameKey = "name"
    private let isCompleteKey = "isComplete"
    private let endDateKey = "endDate"
    private let participantsUidsKey = "participantsUids"
    private let pendingParticipantsUidsKey = "pendingParticipantsUids"
    private let creatorUsernameKey = "creatorUsername"
    private let movementTypeKey = "movementType"
    
    var name: String
    var isComplete: Bool
    var endDate: Date
    var participantsUids: [String] = []
    var pendingParticipantsUids: [String] = []
    var uid: String
    var creatorUsername: String
    var movementType: String
    
    init(name: String, isComplete: Bool, endDate: Date, pendingParticipantsUids: [String] = [], uid: String = UUID().uuidString, creatorUsername: String, movementType: String = "Push ups") {
    
        self.name = name
        self.isComplete = isComplete
        self.endDate = endDate
        self.pendingParticipantsUids = pendingParticipantsUids
        self.uid = uid
        self.creatorUsername = creatorUsername
        self.movementType = movementType
    }
    
    init?(uid: String, dictionary: [String:Any]) {
        
        guard let name = dictionary[nameKey] as? String,
            let isComplete = dictionary[isCompleteKey] as? Bool,
            let endDate = dictionary[endDateKey] as? Double,
            let creatorUsername = dictionary[creatorUsernameKey] as? String,
            let movementType = dictionary[movementTypeKey] as? String
            else { return nil }
        
        let participantsUids = dictionary[participantsUidsKey] as? [String]
        let pendingParticipantsUids = dictionary[pendingParticipantsUidsKey] as? [String]
        
        self.name = name
        self.isComplete = isComplete
        self.endDate = Date(timeIntervalSince1970: endDate)
        self.uid = uid
        self.creatorUsername = creatorUsername
        self.movementType = movementType
        self.participantsUids = participantsUids ?? []
        self.pendingParticipantsUids = pendingParticipantsUids ?? []
        
    }
    
    var dictionaryRepresentation: [String:Any] {
        
        return [nameKey: name, isCompleteKey: isComplete, endDateKey: endDate.timeIntervalSince1970, creatorUsernameKey: creatorUsername, movementTypeKey: movementType, pendingParticipantsUidsKey: pendingParticipantsUids]
    }
}

func == (lhs: Challenge, rhs: Challenge) -> Bool {
    return lhs.uid == rhs.uid
}
