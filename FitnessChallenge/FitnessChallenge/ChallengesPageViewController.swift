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
    var currentPageIndex: Int = 1
    var lastPendingViewControllerIndex: Int?

    let formatter: DateFormatter = {
        let tempFormatter = DateFormatter()
        tempFormatter.dateStyle = .short
        tempFormatter.timeStyle = .short
        tempFormatter.doesRelativeDateFormatting = true
        
        return tempFormatter
    }()
    
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
        
        setViewControllers([currentChallengesVC], direction: .forward, animated: true, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePageVCFromSegmented(notification:)), name: ChallengeController.sharedController.currentSegmentNotification, object: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.index(of: viewController) else { return nil }

        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.index(of: viewController) else { return UIViewController() }
        
        let nextIndex = currentIndex + 1
        
        guard nextIndex <= pages.count - 1 else { return nil }
    
        return pages[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let viewController0 = pendingViewControllers[0] as? ChallengeInvitesViewController {
            self.lastPendingViewControllerIndex = self.pages.index(of: viewController0)
            self.currentPageIndex = 0
        } else if let viewController1 = pendingViewControllers[0] as? CurrentChallengesViewController {
            self.lastPendingViewControllerIndex = self.pages.index(of: viewController1)
            self.currentPageIndex = 1
        } else if let viewController2 = pendingViewControllers[0] as? PastChallengesViewController {
            self.lastPendingViewControllerIndex = self.pages.index(of: viewController2)
            self.currentPageIndex = 2
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let lastPendingViewControllerIndex = self.lastPendingViewControllerIndex else { return }
        
        if completed {
            
            self.currentPageIndex = lastPendingViewControllerIndex
            
            NotificationCenter.default.post(name: ChallengeController.sharedController.currentPageIndexNotification, object: self, userInfo: ["index": currentPageIndex as Any])
        }

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
    
    func updatePageVCFromSegmented(notification: Notification) {
        
        guard let index = notification.userInfo?["segmentIndex"] as? Int else { return }
        if index > currentPageIndex {
            self.currentPageIndex = index
            setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        } else if index < currentPageIndex {
            self.currentPageIndex = index
            setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
        }
        self.currentPageIndex = index
    }
}
