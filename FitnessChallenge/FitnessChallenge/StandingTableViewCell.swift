//
//  StandingTableViewCell.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 7/27/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class StandingTableViewCell: UITableViewCell {
    
    var progressView = UIView()
    var labelTest = UILabel()
    
    var indexPath: IndexPath?
    var athleteDictionary: [Athlete:Int]? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        //        guard let athleteDictionary = athleteDictionary else { print("athleteDictionary was nil in StandingTableViewCell."); return }
        
        //        nameLabel.text = athleteDictionary.keys.first!.username
        //        repsLabel.text = "\(athleteDictionary.values.first!)"
        setupProgressView()
    }
    
    func setupProgressView() {
        
        guard let indexPath = indexPath else { return }
//        progressView.backgroundColor = UIColor.blue
        progressView.backgroundColor = Colors.standingsColorsArray[indexPath.row]
        self.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.contentView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor).isActive = true
//        progressView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.9).isActive = true
//        progressView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5).isActive = true
//        progressView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        let leading = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: progressView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0)
        let tempWidth = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: (0.9 * 0.5), constant: 0)
        
        addConstraints([leading, centerY, height, tempWidth])
    }
}
