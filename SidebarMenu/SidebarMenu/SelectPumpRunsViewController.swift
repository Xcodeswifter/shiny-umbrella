//
//  SelectPumpRunsViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 16/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SelectPumpRunsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    var datalog = [[String: String]]()
    var messagelog = [[String: String]]()
    
    @IBOutlet weak var trackerLabel: UILabel!
    var idtracker:Int = 0
    var pumpID:String = ""
    var pumpType:String = ""
    var isCellSelected:Bool = false
    var pumpNumber = 0
    var userDefaults:UserDefaults = UserDefaults.standard
    @IBOutlet weak var pumpRunsLabel: UITextView!
    @IBOutlet weak var pumpRunsTable: UITableView!
    
    @IBOutlet weak var loadingText: UILabel!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var isMapSelected = false
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pumpRunsTable.delegate = self
        pumpRunsTable.dataSource = self
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        requestPumpRunsServices()
    }
    
    
    
    func requestPumpRunsServices(){
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)
        
        
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumpstatus_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            activitiyViewController.dismiss(animated: true, completion: {
          
            self.parseJSON(json2)
            })
        })
        
        
    }
    
    
@IBAction func goToMap(_ sender: Any) {
    isMapSelected = true
self.performSegue(withIdentifier: "pumprunningtomap", sender: self)

    
    }
    func parseJSON(_ json: JSON) {
        
        
        
        for result in json["pumps"].arrayValue {
            let id = result["pumpID"].stringValue
            let pumpType = result["pumpType"].stringValue
            let statusMessage = result["statusMessage"].stringValue
            let labelNumber = result["label"].stringValue
            let obj = ["pumpID": id, "pumpType": pumpType,"status":statusMessage, "label":labelNumber]
            datalog.append(obj)
            
            
        }
        
        if(datalog.count<=0){
            
            let alert = UIAlertController(title: "Notice", message: "No pump activations found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
            pumpRunsLabel.text = "No pump activation"
            pumpRunsLabel.textColor = UIColor.white
            pumpRunsLabel.font = UIFont(name:"SF UI Text", size:24.0)
            
        }
        
        
        update()
        
    }
    
    
    
    
    func update() {
        
        DispatchQueue.main.async {
            self.pumpRunsTable.reloadData()
        }
    }
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialog = DialogViewController()
        
        let cell: PumpStatusTableViewCell = self.pumpRunsTable.dequeueReusableCell(withIdentifier: "pumprunscell") as! PumpStatusTableViewCell
        
        
        var object = datalog[(indexPath as NSIndexPath).row]
        


        
        if(datalog.count==1){
            if(object["pumpType"]=="0"){

                pumpRunsLabel.text="No runs found"
                pumpRunsLabel.textColor = UIColor.white
                pumpRunsLabel.font = UIFont(name:"SF UI Text", size:24.0)

               dialog.noLogsFoundDialog(type: "pumps")
                
            }
            
        }
        
        
        
        
        
        
        if(object["pumpType"]=="1"){
            
            cell.pumpicon.image =  UIImage(named: "cuadritodiesel")
            
            
            if(object["label"]=="0"){
            cell.pumptext.text = "Diesel"
                
            }else{
                cell.pumptext.text = "Diesel"+" "+object["label"]!
                
            }
        }
        if(object["pumpType"]=="2"){
            cell.pumpicon.image =  UIImage(named: "cuadritoelectrica")
            
            
            
            if(object["label"]=="0"){
            cell.pumptext.text = "Motor"
            }
            else{
                cell.pumptext.text = "Motor"+" "+object["label"]!
 
            }
        }
        if(object["pumpType"]=="3"){
            cell.pumpicon.image =  UIImage(named: "cuadritojockey")
            
            if(object["label"]=="0"){
                cell.pumptext.text = "Jockey"
            }
            else{
                cell.pumptext.text = "Jockey"+" "+object["label"]!
                
            }
            
            }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = datalog[(indexPath as NSIndexPath).row]
        _ = object["status"]! as String
        
        if(object["pumpType"]=="1"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
            
            userDefaults.set(pumpID, forKey: "PUMPID")
            userDefaults.synchronize()
            userDefaults.set(pumpType, forKey: "PUMPTYPE")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "PumpRunsToStatus", sender: self)
            
            
        }
        
        if(object["pumpType"]=="2"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
            
            userDefaults.set(pumpID, forKey: "PUMPID")
            userDefaults.synchronize()
            userDefaults.set(pumpType, forKey: "PUMPTYPE")
            userDefaults.synchronize()
            
            self.performSegue(withIdentifier: "PumpRunsToStatus", sender: self)
            
            
        }
        
        
        
        if(object["pumpType"]=="3"){
            pumpID = object["pumpID"]!

            userDefaults.set(pumpID, forKey: "PUMPID")
            userDefaults.synchronize()

            self.performSegue(withIdentifier: "pumpRunsToJockey", sender: self)
            
            
            
            
            
        }
        
        
        
    }
    
    
    
       
    
    
    
    // MARK- Actions
    
    @IBAction func returntoMain(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func unwindToSelectPumpIssue(segue: UIStoryboardSegue) {}
    @IBAction func unwindToSelectRunningPump(segue: UIStoryboardSegue) {}
    
    
    func parseMessage(_ json: JSON) {
        
        for result in json.arrayValue {
            
            let statusMessage = result.stringValue
            let obj = ["status":statusMessage]
            messagelog.append(obj)
            
            
        }
        
    }
    
    @IBAction func unwindToPumpRunsMenu(segue: UIStoryboardSegue) {}

    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "pumpRunsToSelectTracker", sender: self)

    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "SelectPumpRunsViewController"
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "SelectPumpRunsViewController"
        }

        
        
        
    }
    
    
    
}
