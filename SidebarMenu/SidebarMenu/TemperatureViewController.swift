//
//  TemperatureViewController.swift
//  GCTRACKV2
//  Shows the temperature and water pressure of the system, this is an upcoming feature so this class is not fully implemented
//  Created by Carlos Torres on 9/5/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TemperatureViewController: UIViewController {
    
    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var roomTemperatureLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var WaterLevel: UILabel!
    @IBOutlet weak var waterlevelicon: UIImageView!
    var isMapSelected = false
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs:UserDefaults = UserDefaults.standard
        
        let idTracker = prefs.integer(forKey: "IDTRACKER") as Int
        let params  = [ "id_tracker": idTracker as AnyObject ]
        
                trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getroomstate_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            if(json2["temp"].string=="null"){
                self.temperature.text="Unavailable"
                
                if(json2["lvl"].string=="null"){
                    self.WaterLevel.text = "Unavailable"
                }
            }
                
            else{
                
                //a null value here will crash the app
                self.temperature.text=(json2["temp"].string)!+" "+"F"+"º"
                
                if(json2["lvl"]=="0"){
                    self.WaterLevel.text="Normal"
                }
                if(json2["lvl"]=="1"){
                    self.WaterLevel.text="Low Water"
                    self.waterlevelicon.image = UIImage(named: "waterlow")
                }
                
                if(json2["temp"].intValue<=40){
                    self.WaterLevel.text = "Normal"
                    self.temperatureIcon.image = UIImage(named: "alertedTemperature")
                self.roomTemperatureLabel.textColor = UIColor.red
               self.temperature.textColor = UIColor.red
                }
            }
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true

        self.performSegue(withIdentifier: "pumproomtomap", sender: self)
    
    }
    
    
    
    
    // MARK: - Navigation
    
    
    @IBAction func unwindToPumpRoomConditions(segue: UIStoryboardSegue) {}

    @IBAction func goBack(_ sender: UIButton) {
        self.performSegue(withIdentifier: "main", sender: self)
        
    }
    
    
    
    
    
    
    
    @IBAction func goToSelectTracker(_ sender: Any) {
     isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "pumpRoomToSelectTracker", sender: self)

        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "PumpRoomConditionsViewController"
        }
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "PumpRoomConditionsViewController"
        }
        
        
        
        
        
    }

    
    
}
