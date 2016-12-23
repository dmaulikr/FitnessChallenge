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
    let discreteGraphChartDataSource = DiscreteGraphDataSource()
    
    @IBOutlet weak var graphView: ORKGraphChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        // ORKDiscreteGraphChartView

        guard let discreteGraphChartView = graphView as? ORKDiscreteGraphChartView else { return }
        discreteGraphChartView.dataSource = discreteGraphChartDataSource
        discreteGraphChartView.tintColor = UIColor(red: 244/255, green: 190/255, blue: 74/255, alpha: 1)
        // Optional custom configuration
        discreteGraphChartView.showsHorizontalReferenceLines = true
        discreteGraphChartView.showsVerticalReferenceLines = true
        
        
        
        
        // Bar Chart
        
//        guard let barGraphChartView = graphView as? ORK else { return }
//        barGraphChartView.dataSource = barGraphChartDataSource
//        barGraphChartView.tintColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)//Orange
//        // Optional custom configuration
//        barGraphChartView.showsHorizontalReferenceLines = true
//        barGraphChartView.showsVerticalReferenceLines = true
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
