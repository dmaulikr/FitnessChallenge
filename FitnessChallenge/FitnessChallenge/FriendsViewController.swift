//
//  FriendsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import MessageUI

class FriendsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ReloadTableViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitle("Friends", forSegmentAt: 0)
        segmentedControl.setTitle("Requests", forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        requestsTableView.isHidden = true
        friendCollectionView.isHidden = false
        
        self.view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        requestsTableView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        friendCollectionView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        
        self.inviteBarButtonSetup()
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            
            friendCollectionView.isHidden = false
            requestsTableView.isHidden = true
        case 1:

            friendCollectionView.isHidden = true
            requestsTableView.isHidden = false
            requestsTableView.reloadData()
        default:
            break
        }
    }
    

    //=======================================================
    // MARK: - Collection View Delegate and Data Source
    //=======================================================
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return FriendController.shared.currentUserFriendList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        
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
//            let selectedAthlete = FriendController.shared.currentUserFriendList[indexPath.row - 1]
            print("Friend cell tapped")
        }
    }
    
    //=======================================================
    // MARK: - Tableview Delegate and Data Source
    //=======================================================
    
    var numberOfFriendRequestsPending: Int {
        guard let currentUser = AthleteController.currentUser else { return 0 }
        return currentUser.friendRequestsReceived.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if numberOfFriendRequestsPending > 0 {
            return numberOfFriendRequestsPending
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOfFriendRequestsPending > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? FriendRequestTableViewCell,
                let requester = AthleteController.currentUser?.friendRequestsReceived[indexPath.row] else { return UITableViewCell()}
            
            cell.updateViews(athleteUsername: requester)
            cell.delegate = self
            return cell
        } else {
            
            let cell = UITableViewCell()
            
            cell.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
            cell.textLabel?.text = "No friend requests pending."
            return cell
        }
    }
    
    //=======================================================
    // MARK: - Alert Controllers
    //=======================================================
    
    func presentAddFriendAlertController() {
        
        let alertController = UIAlertController(title: "Add a Friend", message: "What's their username?", preferredStyle: .alert)
        
        var usernameTextField: UITextField?
        alertController.addTextField { (textfield) in
            usernameTextField = textfield
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let username = usernameTextField?.text else { return }
            FriendController.sendFriendRequest(username: username, completion: { (error) in

                guard let error = error else { return }
                
                switch error {
                case .alreadyInvited:
                    self.presentAlreadyInvitedAlert()
                case .alreadyAFriend:
                    self.presentAlreadyAFriendAlert()
                case .noUserWithThatUsername:
                    self.presentNoUserWithThatUsernameAlert()
                }
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentFriendRequestSentAlert() {
        
        let alertController = UIAlertController(title: "Friend Request Sent", message: nil, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlreadyAFriendAlert() {
        
        let alertController = UIAlertController(title: nil, message: "This user is already your friend.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)

        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    func presentAlreadyInvitedAlert() {
        
        let alertController = UIAlertController(title: nil, message: "You have already sent a friend request to this user.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let tryAnotherAction = UIAlertAction(title: "Try Another", style: .default, handler: { (_) in
            self.presentAddFriendAlertController()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(tryAnotherAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //=======================================================
    // MARK: - Text friends invite to app
    //=======================================================
    
    func inviteBarButtonSetup() {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "InviteUserIcon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 29, height: 22)
        button.addTarget(self, action: #selector(textFriendsAnInvite), for: .touchUpInside)
        let item = UIBarButtonItem(customView: button)
        
        self.tabBarController?.navigationItem.setRightBarButton(item, animated: false)
    }
    
    func textFriendsAnInvite() {
        if MFMessageComposeViewController.canSendText() {
            
            let messageController = MFMessageComposeViewController()

            messageController.body = "You should get this app so we can challenge each other! https://goo.gl/pHVeej"
            messageController.messageComposeDelegate = self
            
            self.present(messageController, animated: true, completion: nil)
        } else {
            // messaging not available
            print("messaging not available")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            print("cancelled")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("Invite friend to use app sms message sent")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("Invite friend to use app sms message failed")
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    //=======================================================
    // MARK: - Reload Tableview delegate function
    //=======================================================
    
    func reloadTableView() {
        self.requestsTableView.reloadData()
        self.friendCollectionView.reloadData()
    }
}
