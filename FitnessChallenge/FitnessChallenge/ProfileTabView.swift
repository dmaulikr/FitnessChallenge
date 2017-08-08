//
//  ProfileTabView.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/16/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ProfileTabView: UIView {
    
    weak var delegate: ProfileTabViewDelegate?
    
    var button0 = UIButton()
    var button1 = UIButton()
    
    var imageView0 = UIImageView()
    var imageView1 = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTabViewItem()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTabViewItem() {
        
        // Button0 and imageView0 (Profile)
        
        button0.tag = 0
        button0.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        self.addSubview(button0)
        
        imageView0.image = #imageLiteral(resourceName: "ProfileAndIconLight")
        self.addSubview(imageView0)
        
        // Button1 and imageView1 (Friends)
        
        button1.tag = 1
        button1.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        button1.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        self.addSubview(button1)
        
        imageView1.image = #imageLiteral(resourceName: "FriendsAndIconDark")
        self.addSubview(imageView1)
    }
    
    func setupConstraints() {
        
        button0.translatesAutoresizingMaskIntoConstraints = false
        imageView0.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        
        // button0
        
        let button0Top = NSLayoutConstraint(item: button0, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let button0Bottom = NSLayoutConstraint(item: button0, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let button0Leading = NSLayoutConstraint(item: button0, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let button0Trailing = NSLayoutConstraint(item: button0, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        // imageView0
        
        let imageView0CenterY = NSLayoutConstraint(item: imageView0, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let imageView0CenterX = NSLayoutConstraint(item: imageView0, attribute: .centerX, relatedBy: .equal, toItem: button0, attribute: .centerX, multiplier: 1, constant: 0)
        let imageView0Height = NSLayoutConstraint(item: imageView0, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 1)
        let imageView0Width = NSLayoutConstraint(item: imageView0, attribute: .width, relatedBy: .equal, toItem: imageView0, attribute: .height, multiplier: 5.2, constant: 0)
        
        // button1
        
        let button1Top = NSLayoutConstraint(item: button1, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let button1Bottom = NSLayoutConstraint(item: button1, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let button1Leading = NSLayoutConstraint(item: button1, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let button1Trailing = NSLayoutConstraint(item: button1, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        // imageView1
        
        let imageView1CenterY = NSLayoutConstraint(item: imageView1, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let imageView1CenterX = NSLayoutConstraint(item: imageView1, attribute: .centerX, relatedBy: .equal, toItem: button1, attribute: .centerX, multiplier: 1, constant: 0)
        let imageView1Height = NSLayoutConstraint(item: imageView1, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 1)
        let imageView1Width = NSLayoutConstraint(item: imageView1, attribute: .width, relatedBy: .equal, toItem: imageView1, attribute: .height, multiplier: 5.2, constant: 0)
        
        
        self.addConstraints([imageView0CenterY, imageView0CenterX, imageView0Height, imageView0Width, button0Top, button0Bottom, button0Leading, button0Trailing, button1Top, button1Bottom, button1Leading, button1Trailing, imageView1CenterY, imageView1CenterX, imageView1Height, imageView1Width])
    }
    
    func selectIndex(index: Int) {
        
        imageView0.image = #imageLiteral(resourceName: "ProfileAndIconLight")
        button0.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        imageView1.image = #imageLiteral(resourceName: "FriendsAndIconDark")
        button1.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        
        switch index {
        case 0:
            imageView0.image = #imageLiteral(resourceName: "ProfileAndIconLight")
            button0.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        case 1:
            imageView1.image = #imageLiteral(resourceName: "FriendsAndIconDark")
            button1.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        default:
            break
        }
        
    }
    
    func didTapButton(sender: UIButton) {
        
        selectIndex(index: sender.tag)
        delegate?.tabViewTapped(index: sender.tag)
    }
}

protocol ProfileTabViewDelegate: class {
    
    func tabViewTapped(index: Int)
}
