//
//  StandingsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import ResearchKit

class StandingsViewController: UIViewController, ORKValueStackGraphChartViewDataSource {
    
    //    let barGraphChartDataSource = BarGraphDataSource()
    @IBOutlet weak var graphView: ORKBarGraphChartView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    var currentUserSets: [ORKValueStack] = []
    
    var challenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.currentUserSets = SetController.currentUserSets
            self.graphView.reloadData()
        }
        
        segmentedController.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        
        // ORKBarGraphChartView
        let barGraphChartView = graphView as ORKBarGraphChartView
        graphView.dataSource = self
        //        barGraphChartView.dataSource = self
        barGraphChartView.tintColor = UIColor(red: 244/255, green: 190/255, blue: 74/255, alpha: 1)
        // Optional custom configuration
        barGraphChartView.showsHorizontalReferenceLines = true
        barGraphChartView.showsVerticalReferenceLines = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.graphView.reloadData()
        }
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge()

    }
    
    //=======================================================
    // MARK: - Actions
    //=======================================================
    
    @IBAction func segmentedControllerIndexChanged(_ sender: Any) {
        
        switch segmentedController.selectedSegmentIndex {
            
        case 0:
            title = "1"
        case 1:
            title = "2"
        case 2:
            title = "3"
        default:
            break
        }
    }
    
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueStack {
        return currentUserSets[pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return currentUserSets.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        //        return "\(pointIndex + 1)"
        return AthleteController.currentUser?.username
    }
}

