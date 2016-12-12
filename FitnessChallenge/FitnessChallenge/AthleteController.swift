//
//  AthleteController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import Foundation

class AthleteController {
    
    //C
    //?
    func createAthlete() {
        
        
    }
    
    static func addAthleteToFirebase() {
        
        let athlete = Athlete(username: "usernameMock", email: "mock@email.com", password: "hello")
        
        let allAthletesRef = ChallengeController.baseRef.child("athletes")
        
        let testAthleteRef = allAthletesRef.child(athlete.uid)
        
        testAthleteRef.setValue(athlete.dictionaryRepresentation)
    }
    
    
    //R
    
    
    
    //U
    
    
    
    //D

}

