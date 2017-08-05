//
//  ProfileTabViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 1/16/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ProfileTabViewController: UITabBarController, ProfileTabViewDelegate {

    var tabView: ProfileTabView!
    
    override var selectedIndex: Int {
        didSet {
            tabView?.selectIndex(index: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isHidden = true
        
        let frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 40)
        
        tabView = ProfileTabView(frame: frame)
        tabView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        tabView.delegate = self
        tabView.selectIndex(index: 0)
        view.addSubview(tabView)
    }

    func tabViewTapped(index: Int) {
        
        selectedIndex = index
    }

}
