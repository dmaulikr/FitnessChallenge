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
    static var allSets: [Set] = [] // Do I need this? // FIXME: - Check before committing
    static var participantsTotalsDictionaries: [[Athlete:Int]] = []
    static var athletesForChart: [Athlete] = [] // NEW
    
    //=======================================================
    // MARK: - Functions
    //=======================================================
    
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
        let setRef = allSets.childByAutoId()
        set.uid = setRef.key
        
        setRef.setValue(set.dictionaryRepresentation)
        
    }
    
    static func fetchAllSets(by challengeRef: String, completion: @escaping () -> Void) {
        
        self.participantsTotalsDictionaries = []
        
        guard let currentChallenge = ChallengeController.sharedController.currentlySelectedChallenge, let currentUser = AthleteController.currentUser else { completion(); return }
        
        let allSetsRef = ChallengeController.sharedController.baseRef.child("sets").queryOrdered(byChild: "challengeRef").queryEqual(toValue: currentChallenge.uid)
        allSetsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let setsDictionary = snapshot.value as? [String : [String: Any]]
            
            guard let sets = setsDictionary?.flatMap({ Set(uid: $0.key, dictionary: $0.value) }) else { completion();
                return
            }
            
            // Get current user's sets and append them first.
            let currentUserArrayOfSets: [Set] = sets.filter({$0.athleteRef == currentUser.uid })
            var athleteReps: Int = 0
            for set in currentUserArrayOfSets {
                athleteReps += set.reps
            }
            let currentAthleteDictionary: [Athlete:Int] = [currentUser:athleteReps]
            participantsTotalsDictionaries.append(currentAthleteDictionary)
            
            // Get all other particpants sets into arrays and append each.
            let participantsArrayOfSets: [Set] = sets.filter({ $0.athleteRef != currentUser.uid })
            
            var participantsWithoutCurrentUser: [Athlete] = ChallengeController.sharedController.participatingAthletes
            guard let indexOfCurrentUser = participantsWithoutCurrentUser.index(of: currentUser) else { completion(); return }
            participantsWithoutCurrentUser.remove(at: indexOfCurrentUser)
            
            for participant in participantsWithoutCurrentUser {
                
                let participantSets = participantsArrayOfSets.filter({ $0.athleteRef == participant.uid })
                var athleteTotalReps: Int = 0
                for set in participantSets {
                    let reps = set.reps
                    athleteTotalReps += reps
                }
                participantsTotalsDictionaries.append([participant:athleteReps])
                athleteReps = 0
            }
            
            completion()
        })
    }
}
