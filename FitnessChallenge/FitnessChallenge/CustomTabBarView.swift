//
//  CustomTabBarView.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class CustomTabBarView: UIView {
    
    weak var delegate: CustomTabBarViewDelegate?
    
    var lineAcross = UIView()
    var standingsImageView = UIImageView()
    var addSetView = UIView()
    var addSetImageView = UIImageView()
    var participantsImageView = UIImageView()
    
    var button0 = UIButton()
    var button1 = UIButton()
    var button2 = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabBarItems()
        setupConstraints()
    }
    
    func setupTabBarItems() {
        
        // Standings
        standingsImageView.image = #imageLiteral(resourceName: "StandingsTabBarIcon2x")
        button0.tag = 0
        button0.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        self.addSubview(standingsImageView)
        self.addSubview(button0)
        
        // Line across top
        
        lineAcross.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        
        self.addSubview(lineAcross)

        // Add Set
        
        addSetView.backgroundColor = UIColor(red: 35/255, green: 40/255, blue: 40/255, alpha: 1)// Darkest Gray
        addSetView.layer.cornerRadius = 5
        
        self.addSubview(addSetView)
        
        addSetImageView.image = #imageLiteral(resourceName: "AddSet2x")
        button1.tag = 2
        button1.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        self.addSubview(addSetImageView)
        self.addSubview(button1)
        
        // Participants
        participantsImageView.image = #imageLiteral(resourceName: "ParticipantsIcon2x")
        button2.tag = 1
        button2.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        self.addSubview(participantsImageView)
        self.addSubview(button2)
    }
    
    
    // Constraints
    
    func setupConstraints() {
        
        standingsImageView.translatesAutoresizingMaskIntoConstraints = false
        button0.translatesAutoresizingMaskIntoConstraints = false
        lineAcross.translatesAutoresizingMaskIntoConstraints = false
        addSetView.translatesAutoresizingMaskIntoConstraints = false
        addSetImageView.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        participantsImageView.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        // Standings Image View
        let imageViewCenterY = NSLayoutConstraint(item: standingsImageView, attribute: .centerY, relatedBy: .equal, toItem: button0, attribute: .centerY, multiplier: 1, constant: 0)
        let imageViewCenterX = NSLayoutConstraint(item: standingsImageView, attribute: .centerX, relatedBy: .equal, toItem: button0, attribute: .centerX, multiplier: 1, constant: 0)
        
        
        // Standings Button
        
        let buttonBottom = NSLayoutConstraint(item: button0, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let buttonTop = NSLayoutConstraint(item: button0, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let buttonLeading = NSLayoutConstraint(item: button0, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let buttonTrailing = NSLayoutConstraint(item: button0, attribute: .trailing, relatedBy: .equal, toItem: addSetView, attribute: .leading, multiplier: 1, constant: 0)
        
        // Line Across
        
        let lineBottom = NSLayoutConstraint(item: lineAcross, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let lineLeading = NSLayoutConstraint(item: lineAcross, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let lineTrailing = NSLayoutConstraint(item: lineAcross, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let lineHeight = NSLayoutConstraint(item: lineAcross, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 8)
        
        // Add set View
        
        let viewWidth = NSLayoutConstraint(item: addSetView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.2, constant: 0)
        let viewCenterX = NSLayoutConstraint(item: addSetView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let viewBottom = NSLayoutConstraint(item: addSetView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let viewHeight = NSLayoutConstraint(item: addSetView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.08, constant: 0)
        
        // Add set ImageView
        
        let addSetImageViewCenterY = NSLayoutConstraint(item: addSetImageView, attribute: .centerY, relatedBy: .equal, toItem: button1, attribute: .centerY, multiplier: 1, constant: 0)
        let addSetImageViewCenterX = NSLayoutConstraint(item: addSetImageView, attribute: .centerX, relatedBy: .equal, toItem: button1, attribute: .centerX, multiplier: 1, constant: 0)
        
        // Add set button
        
        let button1Top = NSLayoutConstraint(item: button1, attribute: .top, relatedBy: .equal, toItem: addSetView, attribute: .top, multiplier: 1, constant: 0)
        let button1Bottom = NSLayoutConstraint(item: button1, attribute: .bottom, relatedBy: .equal, toItem: addSetView, attribute: .bottom, multiplier: 1, constant: 0)
        let button1Leading = NSLayoutConstraint(item: button1, attribute: .leading, relatedBy: .equal, toItem: addSetView, attribute: .leading, multiplier: 1, constant: 0)
        let button1Trailing = NSLayoutConstraint(item: button1, attribute: .trailing, relatedBy: .equal, toItem: addSetView, attribute: .trailing, multiplier: 1, constant: 0)
        
        // Participants Image view
        
        let participantsImageViewCenterY = NSLayoutConstraint(item: participantsImageView, attribute: .centerY, relatedBy: .equal, toItem: button2, attribute: .centerY, multiplier: 1, constant: 0)
        let participantsImageViewCenterX = NSLayoutConstraint(item: participantsImageView, attribute: .centerX, relatedBy: .equal, toItem: button2, attribute: .centerX, multiplier: 1, constant: 0)
        
        // Participants Button
        
        let participantsButtonBottom = NSLayoutConstraint(item: button2, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let participantsButtonLeading = NSLayoutConstraint(item: button2, attribute: .leading, relatedBy: .equal, toItem: addSetView, attribute: .trailing, multiplier: 1, constant: 0)
        let participantsButtonTrailing = NSLayoutConstraint(item: button2, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let participantsButtonTop = NSLayoutConstraint(item: button2, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        
        self.addConstraints([imageViewCenterY, imageViewCenterX, buttonBottom, buttonTop, buttonLeading, buttonTrailing, lineBottom, lineLeading, lineTrailing, lineHeight, viewWidth, viewCenterX, viewBottom, viewHeight, addSetImageViewCenterX, addSetImageViewCenterY, button1Top, button1Bottom, button1Leading, button1Trailing, participantsButtonBottom, participantsButtonLeading, participantsButtonTrailing, participantsButtonTop, participantsImageViewCenterY, participantsImageViewCenterX ] )
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectIndex(index: Int) {
        
        standingsImageView.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        addSetImageView.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)
        participantsImageView.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)
        
        switch index {
        case 0:
            standingsImageView.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
            
        case 1:
            addSetImageView.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
            
        case 2:
            participantsImageView.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
            
        default:
            break
        }
    }
    
    func didTapButton(sender: UIButton) {
        
        selectIndex(index: sender.tag)
    
        delegate?.tabBarButtonTapped(index: sender.tag)
        
    }

}


protocol CustomTabBarViewDelegate: class {
    func tabBarButtonTapped(index: Int)
}
