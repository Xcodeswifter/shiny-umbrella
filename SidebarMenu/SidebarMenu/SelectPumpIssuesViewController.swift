//
//  SelectPumpIssuesViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 16/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class SelectPumpIssuesViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {

    var datalog = [[String: String]]()
    var messagelog = [[String: String]]()
    
    @IBOutlet weak var trackerLabel: UILabel!
    var idtracker:Int = 0
    var pumpID:String = ""
    var pumpType:String = ""
    var isMapSelected = false
    var isTrackerMenuSelected = false
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var pumpIssueLabel: UITextView!
    @IBOutlet weak var pumpIssuesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pumpIssuesTable.delegate = self
        pumpIssuesTable.dataSource = self
      
        
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        loadingSpinner.startAnimating()
        
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumpstatus_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
        
    }
    
       
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
   self.performSegue(withIdentifier: "alertomap", sender: self)
    
    }
   
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "AlertsToSelectTracker", sender: self)
        

    
    }
    
    
    func parseJSON(_ json: JSON) {
        let dialog = DialogViewController()
        
        for result in json["pumps"].arrayValue {
            let id = result["pumpID"].stringValue
            let pumpType = result["pumpType"].stringValue
            let statusMessage = result["statusMessage"].stringValue
            let label = result["label"].stringValue

            
            if(pumpType=="3"){
            
            }
            else{
            let obj = ["pumpID": id, "pumpType": pumpType,"status":statusMessage,"label":label]
                datalog.append(obj)
            }
            
        }
        
        if(datalog.count<=0){
           
            dialog.noLogsFoundDialog(type: "alerts")
            
            pumpIssueLabel.text = "No alerts found"
           pumpIssueLabel.textColor = UIColor.white
            pumpIssueLabel.font = UIFont(name:"SF UI Text", size:24.0)
            
            

            stopLoading()
            
            
            
        }
        
        
        update()
        
        
        
        
        
    }
    
    
    
    
    func update() {
    DispatchQueue.main.async {
            self.pumpIssuesTable.reloadData()
        }
    }
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialog = DialogViewController()
        
        let cell: PumpStatusTableViewCell = self.pumpIssuesTable.dequeueReusableCell(withIdentifier: "pumpissuescell") as! PumpStatusTableViewCell
        
        
        let object = datalog[(indexPath as NSIndexPath).row]
        
        
        stopLoading()
        if(datalog.count==1){
            if(object["pumpType"]=="0"){
                pumpIssueLabel.text="No alerts found"
                pumpIssueLabel.textColor = UIColor.white
                pumpIssueLabel.font = UIFont(name:"SF UI Text", size:24.0)

                
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
                
            }else{
                cell.pumptext.text = "Motor"+" "+object["label"]!
                
            }

            
            
            
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        let object = datalog[(indexPath as NSIndexPath).row]
        let statusMessage = object["status"]! as String
        
        
        if(object["pumpType"]=="1"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
            
            
            self.performSegue(withIdentifier: "pumpStatusToIssues", sender: self)
            
            
        }
        
        if(object["pumpType"]=="2"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
                        
            self.performSegue(withIdentifier: "pumpStatusToIssues", sender: self)
            
            
        }
        
        
        
               
        
        
    }
    
    func stopLoading(){
        loadingLabel.isHidden=true
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        
        
    }
    
    
    
    // MARK- Actions
    
    @IBAction func returntoMain(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToPumpStatus(segue: UIStoryboardSegue) {}
     @IBAction func unwindToPumpIssuesMenu(segue: UIStoryboardSegue) {}
    @IBAction func unwindToSelectPumpIssuesViewController(segue: UIStoryboardSegue) {}

    func parseMessage(_ json: JSON) {
        
        
        
        for result in json.arrayValue {
            
            let statusMessage = result.stringValue
            
            
            let obj = ["status":statusMessage]
            
            
            
            
            
            messagelog.append(obj)
            
            
        }
        
        
        
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(!isMapSelected){
            isMapSelected=false

            if(segue.identifier=="pumpStatusToIssues"){
        print("prepare for segue")
        print(pumpType)
        print(pumpID)
        let nextScene =  segue.destination as! SelectedPumpIssueViewController
        nextScene.PumpID = pumpID
        nextScene.pumpType = pumpType
            }
        }
        if(isMapSelected==true){
            print("de que tipo soy")
            print(segue.destination)
           
            if(segue.identifier=="alertomap"){
            
                isMapSelected=false
                let destination = segue.destination as! MapViewController
                destination.segueFromController = "SelectPumpIssuesViewController"
            
            }
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            
            if(segue.identifier=="AlertsToSelectTracker"){
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "SelectPumpIssuesViewController"
        }
        
        }
        
    }
    
    

}
