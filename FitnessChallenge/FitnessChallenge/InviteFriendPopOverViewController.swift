//
//  InviteFriendPopOverViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 4/28/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class InviteFriendPopOverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var friendCollectionView: UICollectionView!
    weak var delegate: RefreshParticipantsCVDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendCollectionView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {
            
            self.friendCollectionView.reloadData()
        }
    }
    
    //=======================================================
    // MARK: - Friend Collection View
    //=======================================================
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChallengeController.sharedController.nonParticipatingFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inviteFriendCell", for: indexPath) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        
        let friend = ChallengeController.sharedController.nonParticipatingFriends[indexPath.row]
        
        cell.updateWith(athlete: friend)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let athlete = ChallengeController.sharedController.nonParticipatingFriends[indexPath.row]
        
        ChallengeController.sharedController.inviteFriendsToChallenge(invitedAthlete: athlete) {
            delegate?.friendWasInvited()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

protocol RefreshParticipantsCVDelegate: class {
    func friendWasInvited()
}
