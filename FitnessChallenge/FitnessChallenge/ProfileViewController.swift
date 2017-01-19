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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.image = AthleteController.currentUser?.profileImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================

    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        AthleteController.logoutAthlete { (success) in
            if success {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
                self.present(loginVC, animated: true, completion: nil)
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
            AthleteController.saveProfilePhotoToFirebase(image: image)
        } else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                profileImageView.image = image
                AthleteController.saveProfilePhotoToFirebase(image: image)
            }
        }
    }


}
