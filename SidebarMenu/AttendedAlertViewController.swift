//
//  AttendedAlertViewController.swift
//  GCTRACKV2BETA
//
//  Created by Apple on 02/02/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AttendedAlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AttendedOrContactIcon: UIImageView!
    @IBOutlet weak var AttendedAlertsOrContactLabel: UITextView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var attendedAlertsTable: UITableView!
    var attendedAlerts = [[String: Any]]()
    var masterTrackersUserAttendedAlerts = [[String: Any]]()
    var selectedFullName:String = ""
    var selectedbusiness:String = ""
    var selectedDestinationId:Int = 0
    var selectedmessage:String = ""
    var idSender:Int = 0
    var segueFromController:String = ""
    
    
    var idtracker: Int = 0
    var prefs:UserDefaults? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        attendedAlertsTable.delegate = self
        attendedAlertsTable.dataSource = self
        prefs = UserDefaults.standard
        idtracker = (prefs?.integer(forKey: "IDTRACKER"))! as Int
        
        if(checkNetworkState()){
            
            if(segueFromController=="AttendedUsersTrackers"){ //Normal Users Only
                
                AttendedAlertsOrContactLabel.text = "Attended Alerts"
                setTextViewAttributes(label:AttendedAlertsOrContactLabel)
                AttendedOrContactIcon.image = UIImage(named: "eventReport")

                
                requestTrackerListService()
                
            }else{//Master users only
                AttendedAlertsOrContactLabel.text = "Contacts"
                setContactTitleTextViewAttributes(label: AttendedAlertsOrContactLabel)
                requestTrackerListService2()
                
            }
            
        }
        
        
        companyLabel.text = prefs?.object(forKey: "NAMEBUSINESS") as! String?
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attendedAlertsTable.delegate = self
        attendedAlertsTable.dataSource = self
        prefs = UserDefaults.standard
        idtracker = (prefs?.integer(forKey: "IDTRACKER"))! as Int
        if(checkNetworkState()){
            // requestTrackerListService()
            
        }
        
        
        companyLabel.text = prefs?.object(forKey: "NAMEBUSINESS") as! String?
    }
    
    
    
    
    func setTextViewAttributes(label:UITextView){
       
        label.textColor = UIColor.white
        UIFont(name:"SF UI Text", size: 21.0)
    
    }
    func setContactTitleTextViewAttributes(label:UITextView){
        
        label.textColor = UIColor.white
        UIFont(name:"SF UI Text", size: 28.0)
        label.frame.origin.x = 99.0
        label.frame.size = CGSize(width: 124.0, height: 52.0)
        
    }

    
    
    func checkNetworkState()->Bool{
        _ = DialogViewController()
        if(!NetworkState.isConnectedToNetwork()){
            
            
            showNoInternetDialog()
            
            
            return false
            
        }
        return true
        
    }
    
    
    
    func showNoInternetDialog(){
        let alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    func requestTrackerListService(){
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)
        

        let prefs:UserDefaults = UserDefaults.standard
        _ = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "time_broadcast":prefs.object(forKey: "ATTENDED")! as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/usrsPerAlert_02-i.php", requestMethod: .post, params: params,completion: { json2 -> () in
           
            
        activitiyViewController.dismiss(animated: true, completion:nil )
            self.parseJSON(json2)
        })
        
        
    }
    
    func requestTrackerListService2(){
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)

        
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "id_user":iduser as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getUsersPerTracker.php", requestMethod: .post, params: params,completion: { json2 -> () in
            activitiyViewController.dismiss(animated: true, completion:nil)
            self.parseUserJSON(json2)
        })
        
        
    }
    
    
    func parseJSON(_ json: JSON) {
        var TIME_SNOOZE_STATE = ""
        
        for result in json["alertedUsers"].arrayValue {
            let name = result["name"].stringValue
            let isAnswered = result["answered"].int
            let time_snooze = result["time_snooze"].stringValue
            
            
            if(time_snooze=="null"){
                TIME_SNOOZE_STATE = "Not Attended"
                
                
            }
            else{
                
                TIME_SNOOZE_STATE = time_snooze
            }
            
            
            if(isAnswered==1){
                
                let obj = ["name": name, "answered": "answered", "time_snooze":TIME_SNOOZE_STATE] as [String : Any]
                attendedAlerts.append(obj )
                
                
            }
            else{
                
                let obj = ["name": name, "answered": "notAnswered", "time_snooze":TIME_SNOOZE_STATE] as [String : Any]
                attendedAlerts.append(obj )
                
            }
            
            
            
            
            
        }
        
        
        update()
        
        
    }
    
    
    
    
    func parseUserJSON(_ json: JSON) {
        
        
        if(json["users"].arrayValue.count<=1){
          
            for result in json["users"].arrayValue{
                let id =  result["id"].intValue
                
                if(id==0){
                    showNoUsersAvailableDialog()

                }
                
            }

        }
        
        
        for result in json["users"].arrayValue {
            let id = result["id"].intValue
            let name = result["name"].stringValue
            
            if(id==0  &&  (json["users"].arrayValue.count<=1)){
                let obj = ["id": id, "name": "Unavailable"] as [String : Any]
                masterTrackersUserAttendedAlerts.append(obj)
                

                
            }else{
                let obj = ["id": id, "name": name] as [String : Any]
                masterTrackersUserAttendedAlerts.append(obj)
                
            }
            
            
            
        }
        
        
        update()
        
        
    }
    
    
    
    
    
    
    
    func showNoUsersAvailableDialog(){
        let alert: UIAlertController =  UIAlertController(title:"Send Message", message:"This GC-Redbox has no other users to write to", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
                                    
 self.performSegue(withIdentifier: "returnToSelectMasterTracker", sender: self)

                                    
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)


        
    }
    
    
    func checkIfTrackerListIsEmpty(json:JSON)->Bool{
        
        if(json["locations"].arrayValue.count<=0){
            
            let dialog = DialogViewController()
            
            dialog.showNoTrackersFoundDialog()
            return true
        }
        
        return false
        
    }
    
    func update() {
        DispatchQueue.main.async {
            
            self.attendedAlertsTable.reloadData()
        }
    }
    
    //MARK Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(segueFromController=="AttendedUsersTrackers"){
        
        return attendedAlerts.count
        
        }
        else{
            
            return masterTrackersUserAttendedAlerts.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = UserDefaults.standard
        
        let cell: AttendedAlertsTableViewCell = self.attendedAlertsTable.dequeueReusableCell(withIdentifier: "celldota") as! AttendedAlertsTableViewCell
        
        
        cell.selectionStyle = .none
        
        if(segueFromController=="AttendedUsersTrackers"){
            let object = attendedAlerts[indexPath.row]
            
            cell.attendedDate.text = object["time_snooze"] as! String?
            cell.nameLabel.text = object["name"] as! String?
            cell.isAttendedImage.image = UIImage(named: object["answered"] as! String)
            
        }
        
        
        if(segueFromController=="MasterTrackers"){
            let object2 = masterTrackersUserAttendedAlerts[indexPath.row]
            
            
            
            cell.nameLabel.text = object2["name"] as! String?
            cell.nameLabel.frame.origin.x = 40
            cell.nameLabel.frame.size = CGSize(width: 540, height: 50)
            cell.nameLabel.font = cell.nameLabel.font.withSize(28)
            cell.attendedDate.text = ""
            cell.forwardArrow.image = UIImage(named: "whitearrow")
            
            
        }
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(segueFromController == "MasterTrackers"){
        let object2 = masterTrackersUserAttendedAlerts[indexPath.row]
        selectedFullName = object2["name"] as! String
        selectedDestinationId = object2["id"] as! Int
        
        if(selectedFullName=="Unavailable"){
            //DO NOTHING
        }
        else{
            segueFromController = "Compose"
            self.performSegue(withIdentifier: "goToReplyMessage", sender: self)
        }
        
        }
        
    }
    
    @IBAction func returnToPreviousScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToEventReport", sender: self)
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if (segueFromController=="MasterTrackers"){
            
            
            let destination = segue.destination as! MasterTrackersViewController
            destination.segueFromController = "MasterTrackers"
            
            // self.performSegue(withIdentifier: "returnToSelectMasterTracker", sender: self)
            
            
            
            
        }
        
        if (segueFromController=="EventReport"){
            
            
            self.performSegue(withIdentifier: "returnToEventReport", sender: self)
            
            
            
            
        }
        
        
        if(segueFromController=="Reply") {
            
            
            let nextScene =  segue.destination as! ReplyMessageViewController
            
            
            
            
            
            nextScene.selectedFullName =  selectedFullName
            
            nextScene.selectedbusiness = ""
            nextScene.selectedmessage =  ""
            nextScene.idSender = idSender
            nextScene.msgType = "Compose a new message"
            nextScene.newMsg = "New Message"
            nextScene.subject = ""
            nextScene.selectedDate = Date().description
            nextScene.idDestination = selectedDestinationId
            
            
        }
        
        
        if(segueFromController=="Compose"){
            let nextScene =  segue.destination as! ReplyMessageViewController
            
            
            
            
            
            nextScene.selectedFullName =  selectedFullName
            
            nextScene.selectedbusiness = ""
            nextScene.selectedmessage =  ""
            nextScene.idSender = idSender
            nextScene.msgType = "Compose a new message"
            nextScene.newMsg = "New Message"
            nextScene.subject = "Subject"
            nextScene.selectedDate = Date().description
            nextScene.idDestination = selectedDestinationId
            

            
            
        }
        
        
        
    }
    
    
    
    
}
