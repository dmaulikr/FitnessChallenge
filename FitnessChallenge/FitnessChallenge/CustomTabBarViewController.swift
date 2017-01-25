//
//  CustomTabBarViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarViewDelegate {
    
    var tabView: CustomTabBarView!
    
    override var selectedIndex: Int {
        didSet {
            tabView.selectIndex(index: selectedIndex)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        
        let frame = CGRect(x: 0,
                           y: view.frame.height - 60,
                           width: view.frame.width,
                           height: 60)
        
        tabView = CustomTabBarView(frame: frame)
        tabView.backgroundColor = UIColor(red: 30/255, green: 31/255, blue: 33/255, alpha: 1)// a dark gray
        tabView.delegate = self
        tabView.selectIndex(index: 0)
        view.addSubview(tabView)
    }
    
    func tabBarButtonTapped(index: Int) {
        
        
        if index == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let addSetVC = storyboard.instantiateViewController(withIdentifier: "addSetViewController") as? AddSetViewController else {
                return }
            self.present(addSetVC, animated: true, completion: nil)
            }
        
        selectedIndex = index
    }
}
