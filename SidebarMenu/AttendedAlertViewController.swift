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
        print("idtracker")
        print(idtracker)
        if(checkNetworkState()){
            //requestTrackerListService()
            requestTrackerListService2()
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
        print("idtraker")
        print(idtracker)
        if(checkNetworkState()){
           // requestTrackerListService()
            
        }
        
        
        companyLabel.text = prefs?.object(forKey: "NAMEBUSINESS") as! String?
    }
    
    
    
    func checkNetworkState()->Bool{
        let dialog = DialogViewController()
        if(!NetworkState.isConnectedToNetwork()){
            
            
            dialog.showNoInternetDialog()
            
           
            return false
            
        }
        return true
        
    }
    
    
    func requestTrackerListService(){
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        print("me lleva el krjo")
        print(prefs.object(forKey: "ATTENDED"))
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "time_broadcast":prefs.object(forKey: "ATTENDED")! as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/usrsPerAlert_02-i.php", requestMethod: .post, params: params,completion: { json2 -> () in
            self.parseJSON(json2)
        })
        
        
    }
    
    func requestTrackerListService2(){
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        print("me lleva el krjo")
        print(prefs.object(forKey: "ATTENDED"))
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "id_user":iduser as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getUsersPerTracker.php", requestMethod: .post, params: params,completion: { json2 -> () in
           print("putoh")
            print(json2)
            self.parseUserJSON(json2)
        })
        
        
    }

    
    func parseJSON(_ json: JSON) {
        var TIME_SNOOZE_STATE = ""

            for result in json["alertedUsers"].arrayValue {
                let name = result["name"].stringValue
                let isAnswered = result["answered"].int
                let time_snooze = result["time_snooze"].stringValue
                
                print("bubas amigo")
                print(time_snooze)
                
                if(time_snooze=="null"){
                    TIME_SNOOZE_STATE = "unavailable"
                    
                    
                }
                else{
                    
                 TIME_SNOOZE_STATE = time_snooze
                }
                
                
                if(isAnswered==1){
                
                    let obj = ["name": name, "answered": "answered", "time_snooze":TIME_SNOOZE_STATE] as [String : Any]
                attendedAlerts.append(obj as! [String : Any])
                
                
            }
                else{
                    
                    let obj = ["name": name, "answered": "notAnswered", "time_snooze":TIME_SNOOZE_STATE] as [String : Any]
                    attendedAlerts.append(obj as! [String : Any])
                    
                }
                
                
                
                
                
        }
        
                
            update()
        
        
    }
    
    
    
    
    func parseUserJSON(_ json: JSON) {
        
        for result in json["users"].arrayValue {
            let id = result["id"].intValue
            let name = result["name"].stringValue
            print("aaaeefe")
            print(name)
            
            if(id==0){
                let obj = ["id": id, "name": "Unavailable"] as [String : Any]
                masterTrackersUserAttendedAlerts.append(obj)

            }else{
                let obj = ["id": id, "name": name] as [String : Any]
                masterTrackersUserAttendedAlerts.append(obj)

            }
            
            
            
        }
        
        
        update()
        
        
    }
    
    

    
    
    
    
    
    func checkIfTrackerListIsEmpty(json:JSON)->Bool{
        
        print(json["locations"].arrayValue.count)
        if(json["locations"].arrayValue.count<=0){
            
            let dialog = DialogViewController()
            
            dialog.showNoTrackersFoundDialog()
            return true
        }
        
        print("es false")
        return false
        
    }
    
    func update() {
        DispatchQueue.main.async {
            
            self.attendedAlertsTable.reloadData()
        }
    }
    
    //MARK Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        
        
        return masterTrackersUserAttendedAlerts.count
  
    
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("entra aqui kbron")
        let prefs:UserDefaults = UserDefaults.standard
        
        let cell: AttendedAlertsTableViewCell = self.attendedAlertsTable.dequeueReusableCell(withIdentifier: "celldota") as! AttendedAlertsTableViewCell
//        
//        let object = attendedAlerts[indexPath.row]
//        
//        cell.attendedDate.text = object["time_snooze"] as! String?
//        cell.nameLabel.text = object["name"] as! String?
//        print("aaaaaa")
//        print(object["answered"])
//        cell.isAttendedImage.image = UIImage(named: object["answered"] as! String)
        
        let object2 = masterTrackersUserAttendedAlerts[indexPath.row]
        
     //hello i am comment
        
        
        cell.nameLabel.adjustsFontSizeToFitWidth=true
        cell.nameLabel.text = object2["name"] as! String?
        cell.attendedDate.text = ""
       
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object2 = masterTrackersUserAttendedAlerts[indexPath.row]
           selectedFullName = object2["name"] as! String
        selectedDestinationId = object2["id"] as! Int
       
        if(selectedFullName=="Unavailable"){
            //DO NOTHING
            print("alola")
        }
        else{
        print("este men")
        segueFromController = "Reply"
        self.performSegue(withIdentifier: "goToReplyMessage", sender: self)
        }
    
    }
    
    @IBAction func returnToPreviousScreen(_ sender: Any) {
        
   self.performSegue(withIdentifier: "returnToEventReport", sender: self)
    
    
    
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("segue from controller")
        print(segue.identifier?.description)
        print(segueFromController)
        
        
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
            
            
            print("valores que se van a enviar al reply")
            
        
            
            nextScene.selectedFullName =  selectedFullName
        
            nextScene.selectedbusiness = "Tracker reply"
            nextScene.selectedmessage =  "Please check maintenance "
            nextScene.idSender = idSender
        nextScene.idDestination = selectedDestinationId
            
            
        }
            
            

    
    }
    


   
}
