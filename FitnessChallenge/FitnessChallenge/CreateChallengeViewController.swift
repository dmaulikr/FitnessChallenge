//
//  CreateChallengeViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class CreateChallengeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var challengeNameTextField: UITextField!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var test: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        friendsCollectionView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    @IBAction func createChallengeButtonTapped(_ sender: Any) {
        
        guard let challengeName = challengeNameTextField.text,
            let currentUser = AthleteController.currentUser else { return }
        
        
        ChallengeController.sharedController.createChallenge(name: challengeName, isComplete: false, endDate: endDatePicker.date, creatorUsername: currentUser.username)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endDatePicker(_ sender: Any) {
        print(endDatePicker.date)
    }
    
    
    func presentAddFriendAlertController() {
        
        let alertController = UIAlertController(title: "Add a Friend", message: "What's their username?", preferredStyle: .alert)
        
        var usernameTextField: UITextField?
        alertController.addTextField { (textfield) in
            usernameTextField = textfield
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            print("\(usernameTextField?.text)")
            guard let username = usernameTextField?.text else { return }
            FriendController.sendFriendRequest(username: username, completion: { (success) in
                if success == true {
                    print("FriendController: Successfully added friend request")
                } else {
                    self.presentNoUserWithThatUsernameAlert()
                }
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func presentNoUserWithThatUsernameAlert() {
        
        let alertController = UIAlertController(title: "Oops", message: "No user with that username found.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { (_) in
            self.presentAddFriendAlertController()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(tryAgainAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //=======================================================
    // MARK: - Collection View Data Source functions
    //=======================================================
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FriendController.shared.currentUserFriendList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? CreateChallengeCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            
            // Make the cell here.
            cell.updateAddButton()
            
            return cell
        } else {
            let athlete = FriendController.shared.currentUserFriendList[indexPath.row - 1]
            
            cell.updateWith(athlete: athlete)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            presentAddFriendAlertController()
        } else {
            // Pull up the selected athlete, and segue to their profile.
            let selectedAthlete = FriendController.shared.currentUserFriendList[indexPath.row - 1]
            print("Friend cell tapped")
        }
    }
    
}
