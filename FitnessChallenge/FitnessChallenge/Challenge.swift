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
    var endDate: String
    var participantsUids: [String] = []
    var pendingParticipantsUids: [String] = []
    var uid: String
    var creatorUsername: String
    var movementType: ChallengeType
    
    init(name: String, isComplete: Bool, endDate: String, pendingParticipantsUids: [String] = [], uid: String = UUID().uuidString, creatorUsername: String, movementType: ChallengeType = .pushups) {
    
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
            let endDate = dictionary[endDateKey] as? String,
            let creatorUsername = dictionary[creatorUsernameKey] as? String,
            let movementType = dictionary[movementTypeKey] as? String
            else { return nil }
        
        let participantsUids = dictionary[participantsUidsKey] as? [String]
        let pendingParticipantsUids = dictionary[pendingParticipantsUidsKey] as? [String]
        
        self.name = name
        self.isComplete = isComplete
        self.endDate = endDate
        self.uid = uid
        self.creatorUsername = creatorUsername
        
        if movementType == "Push ups" {
            self.movementType = .pushups
        } else if movementType == "Plank holds" {
            self.movementType = .plankHolds
        } else if movementType == "Air squats" {
            self.movementType = .airSquats
        } else {
            return nil
        }
        
        self.participantsUids = participantsUids ?? []
        self.pendingParticipantsUids = pendingParticipantsUids ?? []
        
    }
    
    var dictionaryRepresentation: [String:Any] {
        
        return [nameKey: name, isCompleteKey: isComplete, endDateKey: endDate, participantsUidsKey: participantsUids, creatorUsernameKey: creatorUsername, movementTypeKey: movementType.rawValue, pendingParticipantsUidsKey: pendingParticipantsUids]
    }
}

func == (lhs: Challenge, rhs: Challenge) -> Bool {
    return lhs.uid == rhs.uid
}

enum ChallengeType: String {
    case pushups = "Push ups"
    case plankHolds = "Plank holds"
    case airSquats = "Air squats"
}
