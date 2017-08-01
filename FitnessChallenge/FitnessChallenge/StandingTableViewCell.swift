//
//  StandingTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 7/27/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class StandingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    var progressView = UIView()
    var circleView = UIView()
    var profilePicImageView = UIImageView()
    var labelTest = UILabel()
    var percentageToFillProgessBar: CGFloat = 0.0
    var unitMeasurement: String {

        guard let challengeType = ChallengeController.sharedController.currentlySelectedChallenge?.movementType else { return "" }
     
        switch challengeType {
            
        case .pushups:
            return "push up"
        case .airSquats:
            return "air squat"
        case .plankHolds:
            return "second"
        }
    }
    var indexPath: IndexPath?
    var athleteDictionary: [Athlete:Int]? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let athleteDictionary = athleteDictionary,
            let athlete = athleteDictionary.keys.first,
            let athleteReps = athleteDictionary.values.first
            else { print("athleteDictionary was nil in StandingTableViewCell."); return }
        
        if athleteReps == SetController.highestRepCountInCurrentChallenge {
            percentageToFillProgessBar = 1.0
        } else {
            percentageToFillProgessBar = CGFloat(Double(athleteReps) / Double(SetController.highestRepCountInCurrentChallenge))
        }
        
        nameLabel.text = athlete.username
        
        var repsString: String = "\(athleteReps)"
        if athleteReps == 1 {
            repsString += " \(unitMeasurement)"
        } else {
            repsString += " \(unitMeasurement)s"
        }
        
        repsLabel.text = repsString
        
        setupViews(athlete: athlete)
        constrainViews()
    }
    
    func setupViews(athlete: Athlete) {
        
        // Progress View
        guard let indexPath = indexPath else { return }
        
        if indexPath.row < 10 {
            progressView.backgroundColor = Colors.standingsColorsArray[indexPath.row]
            circleView.backgroundColor = Colors.standingsColorsArray[indexPath.row]
        } else {
            progressView.backgroundColor = Colors.standingsColorsArray[indexPath.row % 10]
            circleView.backgroundColor = Colors.standingsColorsArray[indexPath.row % 10]
        }
        
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = self.frame.height * 0.9 / 2
        
        profilePicImageView.clipsToBounds = true
        let cornerRadius = self.frame.height * 0.9 * 0.8 / 2
        profilePicImageView.layer.cornerRadius = cornerRadius
        profilePicImageView.image = athlete.profileImage ?? #imageLiteral(resourceName: "Gray user filled")
        
        self.addSubview(progressView)
        self.addSubview(circleView)
        self.addSubview(profilePicImageView)
    }
    
    func constrainViews() {
        
        // Progress View
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0)
        let width = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: (0.65 * percentageToFillProgessBar), constant: 0)
        
        addConstraints([leading, centerY, height, width])
        
        // Circle View
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXCircleView = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: progressView, attribute: .trailing, multiplier: 1, constant: 0)
        let centerYCircleView = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: progressView, attribute: .centerY, multiplier: 1, constant: 0)
        let heightCircleView = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.9, constant: 0)
        let widthCircleView = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.9, constant: 0)
        
        addConstraints([centerXCircleView, centerYCircleView, heightCircleView, widthCircleView])
        
        // Profile Pic Image View
        profilePicImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXImageView = NSLayoutConstraint(item: profilePicImageView, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYImageView = NSLayoutConstraint(item: profilePicImageView, attribute: .centerY, relatedBy: .equal, toItem: circleView, attribute: .centerY, multiplier: 1, constant: 0)
        let heightImageView = NSLayoutConstraint(item: profilePicImageView, attribute: .height, relatedBy: .equal, toItem: circleView, attribute: .height, multiplier: 0.85, constant: 0)
        let widthImageView = NSLayoutConstraint(item: profilePicImageView, attribute: .width, relatedBy: .equal, toItem: circleView, attribute: .width, multiplier: 0.85, constant: 0)
        
        addConstraints([centerXImageView, centerYImageView, heightImageView, widthImageView])
        
        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: circleView, attribute: .trailing, multiplier: 1, constant: 8)
        let trailingNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -8)
        let bottomNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        addConstraints([leadingNameLabel, trailingNameLabel, bottomNameLabel])
        
        // Reps Label
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingRepsLabel = NSLayoutConstraint(item: repsLabel, attribute: .leading, relatedBy: .equal, toItem: circleView, attribute: .trailing, multiplier: 1, constant: 8)
        let trailingRepsLabel = NSLayoutConstraint(item: repsLabel, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -8)
        let topRepsLabel = NSLayoutConstraint(item: repsLabel, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        addConstraints([leadingRepsLabel, trailingRepsLabel, topRepsLabel])
    }
}






