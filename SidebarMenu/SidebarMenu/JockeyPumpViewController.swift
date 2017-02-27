//
//  JockeyPumpViewController.swift
//  GCTRACKV2
// Class to show the use stats of a selected jockey pump from the PumpStatusViewController
//  Created by Carlos Torres on 9/11/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class JockeyPumpViewController: UIViewController {
    
    @IBOutlet weak var trackerLabel: UILabel!
   
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!
    
    var isMapSelected = false
    var isTrackerMenuSelected = false
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        requestJockeyPumpStatus()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
   self.performSegue(withIdentifier: "jockeytomap", sender: self)
    
    }
    
    @IBAction func jockeyToSelectTracker(_ sender: Any) {
   isTrackerMenuSelected=true
        self.performSegue(withIdentifier: "jockeyToSelectTracker", sender: self)
    }
    
    
    func requestJockeyPumpStatus(){
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker:Int = prefs.integer(forKey: "IDTRACKER") as Int
        let pumpType = prefs.object(forKey: "PUMPID")
       
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "pump":pumpType as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getjockeypumpstatus_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            self.monthLabel.text = json2["month"].stringValue
            self.weekLabel.text = json2["week"].stringValue
            self.dayLabel.text = json2["day"].stringValue
        
        })
        
        
    }
    
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "jockeyToMain", sender: self)
          }
    
    
    @IBAction func refreshJockeyData(_ sender: Any) {
    requestJockeyPumpStatus()
        }
    
    
    
    
    @IBAction func unwindToJockeyPump(segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if(isMapSelected==true){
            isMapSelected=false
                let destination = segue.destination as! MapViewController
                destination.segueFromController = "JockeyPumpViewController"
                
            
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "JockeyPumpViewController"
        }

        
    }

    
    
}
