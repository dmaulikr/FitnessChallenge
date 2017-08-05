//
//  AppearanceController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 8/3/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

enum Theme {
    
    static func configureAppearance() {
        
        UINavigationBar.appearance().barTintColor = UIColor.myDarkestGray()
        UINavigationBar.appearance().tintColor = UIColor.myOrange()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.myOrange()]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
