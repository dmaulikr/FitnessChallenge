//
//  SetController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/3/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import Foundation
import ResearchKit

class SetController {
    
    //=======================================================
    // MARK: - Properties
    //=======================================================
    
    // All sets in currently selected challenge
    static var allSets: [Set] = []
    static var allSetsAsORKValueStacks: [[ORKValueStack]] = []
    static var participantsStacksForTotals: [ORKValueStack] = []
    static var usernamesForChart: [String] = []
    static var currentUserSets: [ORKValueStack] = []
//    static var currentUserSets: [ORKValueStack] {
//        
//        var tempArray: [ORKValueStack] = []
//        let allUserSets = allSets.filter( { $0.athleteRef == AthleteController.currentUserUID } )
//        let setsAsInts = allUserSets.flatMap({ $0.reps })
//        let setsAsNSNumbers = setsAsInts.flatMap({ $0 as NSNumber })
//        let stack = ORKValueStack(stackedValues: setsAsNSNumbers)
//        tempArray.append(stack)
//        return tempArray
//    }
    
    //=======================================================
    // MARK: - Functions
    //=======================================================
    
    static func createCurrentUserSetsAsValueStack(from allSets: [Set]) {
        
        var tempArray: [ORKValueStack] = []
        let allUserSets = allSets.filter( { $0.athleteRef == AthleteController.currentUser?.uid} )
        let setsAsInts = allUserSets.flatMap({ $0.reps })
        let setsAsNSNumbers = setsAsInts.flatMap({ $0 as NSNumber })
        let stack = ORKValueStack(stackedValues: setsAsNSNumbers)
        tempArray.append(stack)
        self.currentUserSets = tempArray
    }
    
    static func createSetsAsValueStack(setsArray: [Set]) -> [ORKValueStack] {
        
        var tempArray: [ORKValueStack] = []
        let setsAsInts = setsArray.flatMap({ $0.reps })
        let setsAsNSNumbers = setsAsInts.flatMap({ $0 as NSNumber })
        let stack = ORKValueStack(stackedValues: setsAsNSNumbers)
        tempArray.append(stack)
        return tempArray
    }
    
    static func addSet(selectedReps: Int) {
        
        guard let user = AthleteController.currentUser,
            let challenge = ChallengeController.sharedController.currentlySelectedChallenge else { return }
        
        let set = Set(movementType: challenge.movementType, reps: selectedReps, athleteRef: user.uid, challengeRef: challenge.uid)
        
        let allSets = ChallengeController.sharedController.baseRef.child("sets")
        let setRef = allSets.child(set.uid)
        
        setRef.setValue(set.dictionaryRepresentation)
        
        
    }
    
    static func fetchAllSets(by challengeRef: String, completion: @escaping () -> Void) {
        
        self.allSetsAsORKValueStacks = []
        self.usernamesForChart = []
        
        guard let currentChallenge = ChallengeController.sharedController.currentlySelectedChallenge, let currentUser = AthleteController.currentUser else { completion(); return }
        
        let allSetsRef = ChallengeController.sharedController.baseRef.child("sets").queryOrdered(byChild: "challengeRef").queryEqual(toValue: currentChallenge.uid)
        allSetsRef.observe(.value, with: { (snapshot) in
            let setsDictionary = snapshot.value as? [String : [String: Any]]
            
            guard let sets = setsDictionary?.flatMap({ Set(uid: $0.key, dictionary: $0.value) }) else { completion()
                return
            }
            
            // Get current user's sets and append them first.
            usernamesForChart.append(currentUser.username)
            let currentUserArrayOfSets: [Set] = sets.filter({$0.athleteRef == currentUser.uid })
            let array = createSetsAsValueStack(setsArray: currentUserArrayOfSets)
            allSetsAsORKValueStacks.append(array)
            
            // Get all other particpants sets into arrays and append each.
            let participantsArrayOfSets: [Set] = sets.filter({ $0.athleteRef != currentUser.uid })
            
            var participantsWithoutCurrentUser: [Athlete] = ChallengeController.sharedController.participatingFriends
            guard let indexOfCurrentUser = participantsWithoutCurrentUser.index(of: currentUser) else { completion(); return }
            participantsWithoutCurrentUser.remove(at: indexOfCurrentUser)
            
//            guard let index = currentChallenge.participantsUids.index(of: currentUser.uid) else { completion(); return }
//            participantsUidsWithoutCurrentUser.remove(at: index)
            
            for participant in participantsWithoutCurrentUser {
                
                usernamesForChart.append(participant.username)
                let participantSets = participantsArrayOfSets.filter({ $0.athleteRef == participant.uid })
                let array = createSetsAsValueStack(setsArray: participantSets)
                allSetsAsORKValueStacks.append(array)
            }
            
            let test = allSetsAsORKValueStacks.joined()
            allSetsAsORKValueStacks = []
            let joined = Array(test)
            allSetsAsORKValueStacks.append(joined)
            
            completion()
        })
    }
    
    static func mergeStackArraysIntoOneForTotals() {
        
        
    }
    
//    static func fetchAllSets(by challengeRef: String, completion: @escaping () -> Void) {
//        
//        self.allSetsAsORKValueStacks = []
//        
//        guard let currentChallenge = ChallengeController.sharedController.currentlySelectedChallenge, let currentUser = AthleteController.currentUser else { completion(); return }
//        
//        let allSetsRef = ChallengeController.sharedController.baseRef.child("sets").queryOrdered(byChild: "challengeRef").queryEqual(toValue: currentChallenge.uid)
//        allSetsRef.observe(.value, with: { (snapshot) in
//            let setsDictionary = snapshot.value as? [String : [String: Any]]
//            
//            guard let sets = setsDictionary?.flatMap({ Set(uid: $0.key, dictionary: $0.value) }) else { completion()
//                return
//            }
//            
//            // Get current user's sets and append them first.
//            let currentUserArrayOfSets: [Set] = sets.filter({$0.athleteRef == currentUser.uid })
//            let array = createSetsAsValueStack(setsArray: currentUserArrayOfSets)
//            allSetsAsORKValueStacks.append(array)
//            
//            // Get all other particpants sets into arrays and append each.
//            let participantsArrayOfSets: [Set] = sets.filter({ $0.athleteRef != currentUser.uid })
//            
//            var participantsUidsWithoutCurrentUser: [String] = currentChallenge.participantsUids
//            guard let index = currentChallenge.participantsUids.index(of: currentUser.uid) else { completion(); return }
//            participantsUidsWithoutCurrentUser.remove(at: index)
//            
//            for participant in participantsUidsWithoutCurrentUser {
//                
//                let participantSets = participantsArrayOfSets.filter({ $0.athleteRef == participant })
//                let array = createSetsAsValueStack(setsArray: participantSets)
//                allSetsAsORKValueStacks.append(array)
//            }
//
//            completion()
//        })
//    }
}
