//
//  PressurePumpViewController.swift
//  GCTRACKV2
//  Class used to display the pressure of the pumps in the system
//  Created by Carlos Torres on 8/30/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PressurePumpViewController:UIViewController{
    var idbusiness:NSInteger = 0
    
    @IBOutlet weak var trackerLabel: UILabel!
    
    @IBOutlet weak var PressureLabel: UILabel!
    var pressurelist=[Int]()
    
    
    @IBOutlet weak var pressureGauge: UIImageView!
    
    var isMapSelected = false
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        getPressure()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        getPressure()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func refreshPressure(_ sender: UIButton) {
        pressurelist.removeAll()
getPressure()
        
    }
    
    @IBAction func backToPressureViewContoller(storyboard: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindToPressurePump(segue: UIStoryboardSegue) {}

    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
        self.performSegue(withIdentifier: "pressureToMap", sender: self)

    }
    
    func getPressure(){
        let prefs:UserDefaults = UserDefaults.standard
        
        let idtracker:Int = prefs.integer(forKey: "IDTRACKER") as Int
        
        
        
        
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkpump_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            self.PressureLabel.text=json2["pressure"].stringValue+"  "+"PSI"
        })
        
        
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkpressurelimits_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            
            self.parsePressureLimitJSON(json: json2)
            
        })
        
    }
    
    
    func parsePressureLimitJSON(json: JSON) {
        
        let activation = json["activation"].intValue
        let lim01 = json["lim01"].intValue
        let lim02 = json["lim02"].intValue
        let lim03 = json["lim03"].intValue
        let lim04 = json["lim04"].intValue
        let lim05 = json["lim05"].intValue
        let pressure=json["pressure"].intValue
        
        
        
        pressurelist.append(activation)
        pressurelist.append(lim01)
        pressurelist.append(lim02)
        pressurelist.append(lim03)
        pressurelist.append(lim04)
        pressurelist.append(lim05)
        pressurelist.append(pressure)
        
        updatePressure()
    }
    
    
    
    
    func updatePressure(){
        let pressure = pressurelist[6]
        
        if(pressure<=0){
            pressureGauge.image = UIImage(named: "PressureEmpty")
        }
            
        else{
            if case pressurelist[1]...pressurelist[2]-1 = pressure{
                pressureGauge.image = UIImage(named: "iconosystempressure5 256x256")
                
            }
            if case pressurelist[2]...pressurelist[3]-1 = pressure{
                pressureGauge.image = UIImage(named: "iconosystempressure4 256x256")
            }
            if case pressurelist[3]...pressurelist[0] = pressure{
                pressureGauge.image = UIImage(named: "iconosystempressure3 256x256")
            }
            if case pressurelist[4]...pressurelist[5]-1 = pressure{
                pressureGauge.image = UIImage(named: "iconosystempressure2 256x256")
            }
            
            
            if (pressure>=pressurelist[5]){
                pressureGauge.image = UIImage(named: "iconosystempressure1 256x256")
            }
            
            
        }
    }
    
    
    
    //MARK- Navigation
    @IBAction func goback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
   self.performSegue(withIdentifier: "pressureToSelectTracker", sender: self)
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "PressureViewController"
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "PressureViewController"
        }

    }
    

    
    
    
    
    
}
