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
    
    let chartColors = [
        UIColor(red: 51/255, green: 0/255, blue: 255/255, alpha: 1)//Blue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChallengeController.sharedController.filterParticipantsInCurrentChallenge()
        
        segmentedController.tintColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        
        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        
        // ORKBarGraphChartView
        let barGraphChartView = graphView as ORKBarGraphChartView
        graphView.dataSource = self
        barGraphChartView.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
        // Optional custom configuration
        barGraphChartView.showsHorizontalReferenceLines = false
        barGraphChartView.showsVerticalReferenceLines = false
        barGraphChartView.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.graphView.reloadData()
        }
        
        

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
    
    //=======================================================
    // MARK: - Chart datasource functions
    //=======================================================
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return SetController.allSetsAsORKValueStacks.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return SetController.allSetsAsORKValueStacks[plotIndex].count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueStack {
        return SetController.allSetsAsORKValueStacks[plotIndex][pointIndex]
    }
    
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return SetController.usernamesForChart[pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, colorForPlotIndex plotIndex: Int) -> UIColor {
        return chartColors[plotIndex]
    }
    
    
}

