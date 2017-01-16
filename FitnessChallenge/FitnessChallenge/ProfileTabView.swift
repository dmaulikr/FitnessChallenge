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
    var button2 = UIButton()
    
    var imageView0 = UIView()
    var imageView1 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTabViewItem() {
        
        // Button0 (Profile)
        button0.tag = 0
        button0.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        self.addSubview(button0)
        
        // Button1 (Friends)
        
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
