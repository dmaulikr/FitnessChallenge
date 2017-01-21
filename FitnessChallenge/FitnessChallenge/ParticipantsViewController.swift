//
//  ParticipantsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.participantsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChallengeController.sharedController.participatingFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantCell", for: indexPath) as? ParticipantsCollectionViewCell else { return UICollectionViewCell() }
        
        let athlete = ChallengeController.sharedController.participatingFriends[indexPath.row]
        
        cell.updateWith(athlete: athlete)
        
        return cell
    }
}
