//
//  StandingsViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit
import ResearchKit

class StandingsViewController: UIViewController {

//    let barGraphChartDataSource = BarGraphDataSource()
    @IBOutlet weak var graphView: ORKBarGraphChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
//        AthleteController.fetchAllAthletes {
//            self.graphView.reloadData()
//        }

//        // ORKBarGraphChartView
//        let barGraphChartView = graphView as ORKBarGraphChartView
//        graphView.dataSource = self
////        barGraphChartView.dataSource = self
//        barGraphChartView.tintColor = UIColor(red: 244/255, green: 190/255, blue: 74/255, alpha: 1)
//        // Optional custom configuration
//        barGraphChartView.showsHorizontalReferenceLines = true
//        barGraphChartView.showsVerticalReferenceLines = true
//    }
//
//    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
//        return AthleteController.currentUserSets[
//    }
//    
//    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueStack {
//        return AthleteController.currentUserSets
//    }
//    
//    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
//        return AthleteController.currentUserSets[plotIndex].count
//    }
//
//    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
//        <#code#>
//    }
    }
}
