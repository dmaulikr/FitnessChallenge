//
//  ParticipantsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, RefreshParticipantsCVDelegate {
    
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        participantsCollectionView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {
            self.participantsCollectionView.reloadData()
        }
        inviteBarButtonSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.setRightBarButton(nil, animated: false)
    }
    
    //=======================================================
    // MARK: - Invite Friend functions
    //=======================================================
    
    func inviteBarButtonSetup() {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "InviteUserIcon"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 29, height: 22)
        btn.addTarget(self, action: #selector(inviteFriendToChallenge), for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)

        self.tabBarController?.navigationItem.setRightBarButton(item, animated: false)
    }
    
    func inviteFriendToChallenge() {
        
        // Present a popover view
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addParticipantsPopOver") as? InviteFriendPopOverViewController else { return }
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1/6)
        
        let popController = vc.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        popController?.barButtonItem = self.tabBarController?.navigationItem.rightBarButtonItem
        popController?.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
    //=======================================================
    // MARK: - Collection View Delegate and Data Source
    //=======================================================
    
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
                    headerView.headerLabel.text = "Pending Invites"
                case 1:
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
                numberOfItems = ChallengeController.sharedController.participatingAthletes.count
            default:
                break
                
            }
        } else {
            numberOfItems = ChallengeController.sharedController.participatingAthletes.count
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
                tempAthlete = ChallengeController.sharedController.participatingAthletes[indexPath.row]
            default:
                break
            }
            
        } else {
            tempAthlete = ChallengeController.sharedController.participatingAthletes[indexPath.row]
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
    
    //=======================================================
    // MARK: - RefreshParticipantsCVDelegate function
    //=======================================================
    
    func friendWasInvited() {
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge {
            self.participantsCollectionView.reloadData()
        }
    }
    
}
