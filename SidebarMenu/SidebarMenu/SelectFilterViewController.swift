//
//  SelectFilterViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 08/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SelectFilterViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var pumpHistoryButton: UIButton!
    @IBOutlet weak var pressureHistoryButton: UIButton!
    @IBOutlet weak var selectTrackerButton: UIButton!
    @IBOutlet weak var engineproblemsbutton: UIButton!
    @IBOutlet weak var enginerunsbutton: UIButton!
    
    var isMapSelected = false
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    
    func loadData(){
        if(!NetworkState.isConnectedToNetwork()){
            let dialog = DialogViewController()
            
            showNoInternetDialog()
            
            
            selectTrackerButton.setTitle("No internet connection", for: .normal)
        }
            
            
        else{
            
            let prefs:UserDefaults = UserDefaults.standard
            
            print("tracker data")
            selectTrackerButton.setTitle(prefs.object(forKey: "NAMEBUSINESS") as? String, for: .normal)
       

            
        }
        
    }
    
    
    
    
    func showNoInternetDialog(){
        var alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Mark Actions
    @IBAction func goToalarms(_ sender: Any) {
        self.performSegue(withIdentifier: "SelectFilterToPumpIssues", sender: self)

    }
    @IBAction func goTodatalog(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPumpHistory", sender: self)

    }
    @IBAction func goToengineruns(_ sender: Any) {
        self.performSegue(withIdentifier: "selectFilterToPumpRuns", sender: self)

    }
    
    @IBAction func goToTenDaysPressure(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPressureHistory", sender: self)

    }
    
    
    @IBAction func chooseTracker(_ sender: Any) {
        isTrackerMenuSelected = true
   self.performSegue(withIdentifier: "goToSelectTrackerFromFilter", sender: self)    
    }
    
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
    self.performSegue(withIdentifier: "datalogmainmenutomap", sender: self)
    
    }
    
    
    @IBAction func chooseTrackerFromAddress(_ sender: Any) {
        isTrackerMenuSelected = true
    self.performSegue(withIdentifier: "goToSelectTrackerFromFilter", sender: self)
    
    }
    
    @IBAction func unwindToSelectFilter(segue: UIStoryboardSegue) {}
    
    @IBAction func chooseTrackerFromDownButton(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "goToSelectTrackerFromFilter", sender: self)

    
    }
    
    
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "exitToMain", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected = false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "SelectFilterViewController"
            
        }
        if(isTrackerMenuSelected){
            isTrackerMenuSelected = false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "SelectFilterViewController"
            
        }

        
        
        
    }

    
    
}
