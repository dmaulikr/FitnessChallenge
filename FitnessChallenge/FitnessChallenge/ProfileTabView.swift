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
        
        // Button1 and imageView1 (Friends)
        
        button1.tag = 1
        button1.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        button1.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        self.addSubview(button1)
        
        imageView1.image = #imageLiteral(resourceName: "FriendsAndIconDark")
    }
    
    func setupConstraints() {
        
        
    }
    
    func selectIndex(index: Int) {
        
        
        
//        switch index {
//        case 0:
//            //
//        case 1:
//            //
//        default:
//            break
//        }
        
    }
    
    func didTapButton(sender: UIButton) {
        
        selectIndex(index: sender.tag)
        delegate?.tabViewTapped(index: sender.tag)
    }



}

protocol ProfileTabViewDelegate: class {
    
    func tabViewTapped(index: Int)
}
