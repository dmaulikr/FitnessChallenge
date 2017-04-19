//
//  ParticipantsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        participantsCollectionView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.participantsCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if ChallengeController.sharedController.currentChallengePendingInvitees.count == 0 {
            return 1
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "ParticipantHeaderView",
                                                                                   for: indexPath) as? ParticipantsCollectionReusableView
                else { return UICollectionReusableView() }
            
            if ChallengeController.sharedController.currentChallengePendingInvitees.count > 0 {
                
                switch indexPath.section {
                case 0:
                    //                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Pending Invites")
                    //                attributeString.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                    //                headerView.headerLabel.attributedText = attributeString
                    headerView.headerLabel.text = "Pending Invites"
                case 1:
                    //                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Current Participants")
                    //                attributeString.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                    //                headerView.headerLabel.attributedText = attributeString
                    headerView.headerLabel.text = "Participants"
                    
                default:
                    break
                }
                
                return headerView
                
            } else {
                headerView.headerLabel.text = "Participants"
                return headerView
            }
            
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems: Int = 0
        
        if ChallengeController.sharedController.currentChallengePendingInvitees.count > 0 {
            switch section {
            case 0:
                numberOfItems = ChallengeController.sharedController.currentChallengePendingInvitees.count
            case 1:
                numberOfItems = ChallengeController.sharedController.participatingFriends.count
            default:
                break
                
            }
        } else {
            numberOfItems = ChallengeController.sharedController.participatingFriends.count
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participantCell", for: indexPath) as? ParticipantsCollectionViewCell else { return UICollectionViewCell() }
        
        var tempAthlete: Athlete?
        
        if ChallengeController.sharedController.currentChallengePendingInvitees.count > 0 {
        
        switch indexPath.section {
        case 0:
            tempAthlete = ChallengeController.sharedController.currentChallengePendingInvitees[indexPath.row]
        case 1:
            tempAthlete = ChallengeController.sharedController.participatingFriends[indexPath.row]
        default:
            break
        }
            
        } else {
            tempAthlete = ChallengeController.sharedController.participatingFriends[indexPath.row]
        }
        guard let athlete = tempAthlete else { return UICollectionViewCell() }
        cell.updateWith(athlete: athlete)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width * 0.28
        let height = width / 0.75
        return CGSize(width: width, height: height)
    }
    
}
