//
//  FriendsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var requestsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.setTitle("Friends", forSegmentAt: 0)
        segmentedControl.setTitle("Requests", forSegmentAt: 1)
    }
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        
//        switch segmentedControl.selectedSegmentIndex
//        {
//        case 0:
//            textLabel.text = "First Segment Selected";
//            
//        case 1:
//            textLabel.text = "Second Segment Selected";
//        default:
//            break
//        }
    }
    

    //=======================================================
    // MARK: - Collection View Delegate and Data Source
    //=======================================================
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentUser = AthleteController.currentUser else { return 0 }
        return currentUser.friendsUids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        
        
        
        return cell
    }
}
