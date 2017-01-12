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
    
    var currentUserSets: [ORKValueStack] = []
    
    var challenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let challenge = challenge else { return }
        
        SetController.fetchAllSets(by: challenge.uid) {
            self.currentUserSets = SetController.currentUserSets
            self.graphView.reloadData()
        }
        
        
        
        
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

