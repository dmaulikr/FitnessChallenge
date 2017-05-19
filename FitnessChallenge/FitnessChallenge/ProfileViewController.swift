//
//  ProfileViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        usernameLabel.text = AthleteController.currentUser?.username
        emailLabel.text = AthleteController.currentUser?.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor(red: 91/255, green: 91/255, blue: 91/255, alpha: 1).cgColor// Lighter Gray
        
        if AthleteController.currentUser?.profileImageUrl != "" {
            profileImageView.image = AthleteController.currentUser?.profileImage
        } else {
            profileImageView.image = #imageLiteral(resourceName: "Gray user filled")
        }
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================

//    @IBAction func changePasswordButtonTapped(_ sender: Any) {
//        
//    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        AthleteController.logoutAthlete { (success) in
            if success {
                AthleteController.currentUser = nil
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
                self.present(loginVC, animated: true, completion: nil)
                AthleteController.fetchAllAthletes {
                    print("Successfully fetched all athletes after logout")
                }
            } else {
                //
            }
        }
    }
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Change Photo", message: "How would you like to get the photo?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            profileImageView.image = image
            AthleteController.currentUser?.profileImage = image
            AthleteController.saveProfilePhotoToFirebase(image: image)
        } else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                profileImageView.image = image
                AthleteController.currentUser?.profileImage = image
                AthleteController.saveProfilePhotoToFirebase(image: image)
            }
        }
    }


}
