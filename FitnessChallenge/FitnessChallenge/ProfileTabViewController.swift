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
        
//        guard let tabView = tabView else { return }

        tabBar.isHidden = true
        
        let frame = CGRect(x: 0.0, y: 15.0, width: view.frame.width, height: 50)
        
        tabView = ProfileTabView(frame: frame)
        tabView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        tabView.delegate = self
        tabView.selectIndex(index: 0)
        view.addSubview(tabView)
    }

    func tabViewTapped(index: Int) {
        
        if index == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let friendsVC = storyboard.instantiateViewController(withIdentifier: "FriendsTab")
            self.present(friendsVC, animated: true, completion: nil)
        }
        
        selectedIndex = index
    }

}
