//
//  AlarmViewController.swift
//  GCTRACKV2
// Class to represent the alarm screen(with sound) this class is called via Appdelegate when a push notification is triggered
//  Created by Carlos Torres on 9/12/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
import SwiftyJSON

class AlarmViewController: UIViewController {
    
    
    
    @IBOutlet weak var pumpFailureLabel: UITextView!
    
    var alarm:Int=1
    let prefs:UserDefaults = UserDefaults.standard
    var isMultipleTrackerText:String = ""
    var alertedTrackerData = [[String: String]]()
    let sound = AlarmSound()
    let isSoundPlaying = UserDefaults.standard
    
    
    //optimized Function
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAlertedTrackers()
        sound.playSound()
    
        
        isSoundPlaying.set(0, forKey: "SOUND")
        
        
    }
    //optimized Function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAlertedTrackers()
        isSoundPlaying.set(0, forKey: "SOUND")
        if(isSoundPlaying.integer(forKey: "SOUND")==0){
            sound.playSound()
             isSoundPlaying.set(1, forKey: "SOUND")
        }

        
        
       

    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAlertedTrackers()
        sound.playSound()
        isSoundPlaying.set(1, forKey: "SOUND")

    }
    
   
    func requestAlertedTrackers(){
        let params:[String:AnyObject]=[ "id_user": prefs.object(forKey: "IDUSER") as AnyObject ]
        
        print(prefs.object(forKey: "IDUSER") as! Int)
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getalertedtrackers_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            
            self.isMultipleTrackerText =  self.parseJSON(json2)
            print(self.isMultipleTrackerText)
            
            self.prefs.set(self.isMultipleTrackerText,  forKey: "ALERT")
            self.prefs.synchronize()
            
            self.pumpFailureLabel.text=self.isMultipleTrackerText
            self.setTextViewAttributes(pumpFailureLabel: self.pumpFailureLabel)
            
        })
        
        
        
        
    }
    
    
    //optimized
    @IBAction func warningtoMain(_ sender: AnyObject) {

        sound.stopSounds()
        isSoundPlaying.set(0, forKey: "SOUND")
        if(pumpFailureLabel.text.contains("Multiple")){
            self.performSegue(withIdentifier: "alarmToMultipleTrackers", sender: self)
            
        }
        
        //this is the if that causes the app to crash it is removed
       // else if(alertedTrackerData.count>0){
            //let alertedTracker = alertedTrackerData[0]
            
          // prepareAlertedTrackerInfo(alertedTrackerData: alertedTracker)
        prefs.set(1, forKey:"ALERTEDTRACKER")
        prefs.synchronize()
        
            self.performSegue(withIdentifier: "alarmtomain2", sender: self)
            
       // }
    }
    
    
    
    
    
    func prepareAlertedTrackerInfo(alertedTrackerData:[ String: String]){
        prefs.set(alertedTrackerData["idtracker"]!, forKey: "IDTRACKER")
        prefs.synchronize()
        
        prefs.set(alertedTrackerData["name"]!, forKey: "NAMEBUSINESS")
        prefs.synchronize()
        
        prefs.set(alertedTrackerData["address"]!, forKey: "ADDRESS")
        prefs.synchronize()
        prefs.set(1, forKey:"ALERTEDTRACKER")
        prefs.synchronize()
        
        
    }
    
    
    
    func parseJSON(_ json: JSON)-> String {
        
        var text:String=""
        var text2:String=""
        var fullPumpIssueText:String = ""
        
       
        
        if(json["alertedtrackers"].arrayValue.count>1){
            return "Multiple Trackers with problems"
        }
        
        for result in json["alertedtrackers"].arrayValue {
            text =  result["statusMessage"].stringValue+"  in Date: "+result["date"].stringValue+"\n"
            text2 = " at: "+result["name"].stringValue+"  "+result["address"].stringValue
            fullPumpIssueText = text+text2
            
            
            let address = result["address"].stringValue
            let name = result["name"].stringValue
            let idTracker = result["id_tracker"].stringValue
            let date = result["date"].stringValue
            let status = result["statusMessage"].stringValue
            let obj = ["idtracker": idTracker, "name": name,"address":address,"date":date, "status":status]
            alertedTrackerData.append(obj)
            
        }
        
        
        
        return fullPumpIssueText
    }
    
    
    func setTextViewAttributes(pumpFailureLabel:UITextView){
        
        pumpFailureLabel.textColor = UIColor.white
        pumpFailureLabel.font = UIFont(name:"SF UI Text", size:21.0)

        
    }
    
    
}
