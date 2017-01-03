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
    
    static var currentUserSets: [ORKValueStack] {
        
        var tempArray: [ORKValueStack] = []
        let allUserSets = allSets.filter( { $0.athleteRef == AthleteController.currentUserUID } )
        let setsAsInts = allUserSets.flatMap({ $0.reps })
        let setsAsNSNumbers = setsAsInts.flatMap({ $0 as NSNumber })
        let stack = ORKValueStack(stackedValues: setsAsNSNumbers)
        tempArray.append(stack)
        return tempArray
    }
    
    //=======================================================
    // MARK: - Functions
    //=======================================================
    
    static func addSet(selectedReps: Int) {
        
        guard let user = AthleteController.currentUser,
            let challenge = ChallengeController.sharedController.currentlySelectedChallenge else { return }
        
        let set = Set(movementType: challenge.movementType, reps: selectedReps, athleteRef: user.uid, challengeRef: challenge.uid)
        
        let allSets = ChallengeController.sharedController.baseRef.child("sets")
        let setRef = allSets.child(set.uid)
        
        setRef.setValue(set.dictionaryRepresentation)
        
        
    }
    
    static func fetchAllSets(by challengeRef: String, completion: @escaping () -> Void) {
        
        guard let currentChallengeUid = ChallengeController.sharedController.currentlySelectedChallenge?.uid else { return }
        
        let allSetsRef = ChallengeController.sharedController.baseRef.child("sets").queryEqual(toValue: currentChallengeUid, childKey: "challengeRef")
        allSetsRef.observe(.value, with: { (snapshot) in
            let setsDictionary = snapshot.value as? [String : [String: Any]]
            
            guard let sets = setsDictionary?.flatMap({ Set(uid: $0.key, dictionary: $0.value) }) else {
                return
            }
            
            SetController.allSets = sets
            completion()
        })
    }
}
