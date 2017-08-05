//
//  Colors.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 7/28/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func myDarkestGray() -> UIColor {
        return UIColor(red: 30/255, green: 31/255, blue: 33/255, alpha: 1)
    }
    
    class func myOrange() -> UIColor {
        return UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
    }
}

class Colors {
    
    static let standingsColorsArray = [
        // Orange Gradient
        UIColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 25.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 51.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 76.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 193/255.0, blue: 102/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 203/255.0, blue: 127/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 153.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 224.0/255.0, blue: 178.0/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 234/255.0, blue: 204/255.0, alpha: 1.0),
        UIColor(red: 255.0/255.0, green: 244/255.0, blue: 229/255.0, alpha: 1.0)
    ]
}

/* Colors
 
 UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
 UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
 
 // Blue gradient
 UIColor(red: 31.0/255.0, green: 95.0/255.0, blue: 172.0/255.0, alpha: 1.0),
 UIColor(red: 52.0/255.0, green: 109.0/255.0, blue: 179.0/255.0, alpha: 1.0),
 UIColor(red: 73.0/255.0, green: 124.0/255.0, blue: 187.0/255.0, alpha: 1.0),
 UIColor(red: 93.0/255.0, green: 139.0/255.0, blue: 195.0/255.0, alpha: 1.0),
 UIColor(red: 113.0/255.0, green: 153.0/255.0, blue: 202.0/255.0, alpha: 1.0),
 UIColor(red: 134.0/255.0, green: 167.0/255.0, blue: 210.0/255.0, alpha: 1.0),
 UIColor(red: 154.0/255.0, green: 182.0/255.0, blue: 217.0/255.0, alpha: 1.0),
 UIColor(red: 174.0/255.0, green: 197.0/255.0, blue: 225.0/255.0, alpha: 1.0),
 UIColor(red: 194.0/255.0, green: 211.0/255.0, blue: 232.0/255.0, alpha: 1.0),
 UIColor(red: 215.0/255.0, green: 226.0/255.0, blue: 240.0/255.0, alpha: 1.0)
 
 // Redish Orange Gradient
 UIColor(red: 221.0/255.0, green: 57.0/255.0, blue: 0.0/255.0, alpha: 1.0),
 UIColor(red: 224.0/255.0, green: 76.0/255.0, blue: 25.0/255.0, alpha: 1.0),
 UIColor(red: 227.0/255.0, green: 96.0/255.0, blue: 51.0/255.0, alpha: 1.0),
 UIColor(red: 231.0/255.0, green: 116.0/255.0, blue: 76.0/255.0, alpha: 1.0),
 UIColor(red: 234.0/255.0, green: 136.0/255.0, blue: 102.0/255.0, alpha: 1.0),
 UIColor(red: 238.0/255.0, green: 156.0/255.0, blue: 127.0/255.0, alpha: 1.0),
 UIColor(red: 241.0/255.0, green: 175.0/255.0, blue: 153.0/255.0, alpha: 1.0),
 UIColor(red: 244.0/255.0, green: 195.0/255.0, blue: 178.0/255.0, alpha: 1.0),
 UIColor(red: 248.0/255.0, green: 215.0/255.0, blue: 204.0/255.0, alpha: 1.0),
 UIColor(red: 251.0/255.0, green: 235.0/255.0, blue: 229.0/255.0, alpha: 1.0)
 
 // Purple Gradient
 UIColor(red: 88.0/255.0, green: 59.0/255.0, blue: 143.0/255.0, alpha: 1.0),
 UIColor(red: 104.0/255.0, green: 78.0/255.0, blue: 154.0/255.0, alpha: 1.0),
 UIColor(red: 121.0/255.0, green: 98.0/255.0, blue: 165.0/255.0, alpha: 1.0),
 UIColor(red: 138.0/255.0, green: 117.0/255.0, blue: 176.0/255.0, alpha: 1.0),
 UIColor(red: 154.0/255.0, green: 137.0/255.0, blue: 187.0/255.0, alpha: 1.0),
 UIColor(red: 171.0/255.0, green: 157.0/255.0, blue: 199.0/255.0, alpha: 1.0),
 UIColor(red: 188.0/255.0, green: 176.0/255.0, blue: 210.0/255.0, alpha: 1.0),
 UIColor(red: 204.0/255.0, green: 196.0/255.0, blue: 221.0/255.0, alpha: 1.0),
 UIColor(red: 221.0/255.0, green: 215.0/255.0, blue: 232.0/255.0, alpha: 1.0),
 UIColor(red: 238.0/255.0, green: 235.0/255.0, blue: 243.0/255.0, alpha: 1.0)
 
 */
