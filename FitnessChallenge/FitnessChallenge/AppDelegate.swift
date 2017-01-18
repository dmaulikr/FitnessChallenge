//
//  AppDelegate.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/8/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()

        if FIRAuth.auth()?.currentUser != nil {
            guard let currentUser = FIRAuth.auth()?.currentUser else { return true }
            let uid = currentUser.uid
            
            AthleteController.fetchCurrentUserFromFirebaseWith(uid: uid, completion: { 
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let challengesVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChallengesView") as UIViewController
                if let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = navigationVC
                self.window?.makeKeyAndVisible()
                }
            })
        } else {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginScreen") as UIViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = loginVC
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/* Colors

UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
UIColor(red: 35/255, green: 40/255, blue: 40/255, alpha: 1)// Darkest Gray
UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
 
*/
