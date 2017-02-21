//
//  ChallengesPageViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 2/14/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class ChallengesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        guard let challengeInvitesVC: UIViewController = storyboard?.instantiateViewController(withIdentifier: "challengeInvitesVC"),
        let currentChallengesVC: UIViewController = storyboard?.instantiateViewController(withIdentifier: "currentChallengesVC"),
        let pastChallengesVC: UIViewController = storyboard?.instantiateViewController(withIdentifier: "pastChallengesVC")
            else { return }
        
        pages.append(challengeInvitesVC)
        pages.append(currentChallengesVC)
        pages.append(pastChallengesVC)
        
        setViewControllers([challengeInvitesVC], direction: .forward, animated: true, completion: nil)
        
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.index(of: viewController) else { return UIViewController() }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.index(of: viewController) else { return UIViewController() }
        let nextIndex = (currentIndex + 1) % pages.count
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
