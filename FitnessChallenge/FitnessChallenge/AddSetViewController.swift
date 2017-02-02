//
//  AddSetViewController.swift
//  FitnessChallenge
//
//  Created by Aaron Martinez on 12/13/16.
//  Copyright © 2016 Aaron Martinez. All rights reserved.
//

import UIKit

class AddSetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var repsPickerView: UIPickerView!
    
    static var selectedReps: Int?
    
    var pickerData: [String] = []
    
    var pickerValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.view.backgroundColor = UIColor(red: 45/255, green: 50/255, blue: 55/255, alpha: 1)//Background Dark Gray
        
        pickerData = ["Select Reps","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"]
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
//    {
//        var pickerLabel = UILabel()
//        pickerLabel.textColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
////        pickerLabel.text = "PickerView Cell Title"
//        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
//        pickerLabel.font = UIFont(name: "Avenir", size: 18) // In this use your custom font
//        pickerLabel.textAlignment = NSTextAlignment.center
//        return pickerLabel
//    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let reps = pickerValue else { return }
        SetController.addSet(selectedReps: reps)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //=======================================================
    // MARK: - Picker Data Source and Delegate
    //=======================================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let font = UIFontDescriptor(name: "Avenir Next", size: 30)
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.textColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1)// Light Gray
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont(descriptor: font , size: 30)
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            let alertController = UIAlertController(title: nil, message: "Pick your rep count.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)

            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
        let reps = row
        self.pickerValue = reps
        }
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
