//
//  LastTenEngineRunTableViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 08/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LastTenEngineRunTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var trackerLabel: UILabel!
    
    @IBOutlet weak var engineRunTable: UITableView!
    var datalog = [[String: String]]()
    var pumpID:String?
    var pumpType:String?
    var prefs:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var pumpLabelName: UITextView!
    @IBOutlet weak var pumpIcon: UIImageView!
    var isMapSelected = false
    var isTrackerMenuSelected = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engineRunTable.delegate=self
        engineRunTable.dataSource=self
        engineRunTable.delegate=self
        engineRunTable.dataSource=self
        engineRunTable.layoutMargins = UIEdgeInsets.zero
        engineRunTable.separatorInset = UIEdgeInsets.zero
        engineRunTable.tableFooterView = UIView(frame: CGRect.zero)
        loadingSpinner.startAnimating()
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        loadData()
        
        
    }
    
    
    
    
    @IBAction func goToMap(_ sender: Any) {
    isMapSelected = true
        self.performSegue(withIdentifier: "selectedpumpruntomap", sender: self)
    
    }
    
    
    
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "lastTenPumpRunsToSelectTracker", sender: self)
        

    
    }
    
    
    @IBAction func unwindToSelectPumpRun(segue: UIStoryboardSegue) {}

    
    func loadData(){
        
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker = prefs.integer(forKey: "IDTRACKER")
        let pumpID = prefs.object(forKey: "PUMPID") as! String
        pumpType = prefs.object(forKey: "PUMPTYPE") as! String
        
        print(idtracker)
        print(pumpID)
        let params  = [ "id_tracker": idtracker as AnyObject,"pumpID":pumpID as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getlastruns_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            print(json2)
            self.parseJSON(json: json2)
            
        })
        
        if(pumpType=="1"){
            pumpLabelName.text="Diesel Pump"
            pumpLabelName.textColor = UIColor.white
            pumpLabelName.font = UIFont(name:"SF UI Text", size:21.0)
            

            pumpIcon.image = UIImage(named: "cuadritodiesel")
        }
        
        
        if(pumpType=="2"){
            pumpLabelName.text="Electric Motor"
            pumpLabelName.textColor = UIColor.white
            pumpLabelName.font = UIFont(name:"SF UI Text", size:21.0)
            
            pumpIcon.image = UIImage(named: "cuadritoelectrica")
        }
        
        
    }
    
    
    
    func parseJSON(json:JSON){
       
        
        
        if(!checkIfPumpRunListIsEmpty(json: json)){
        for result in json["lastRuns"].arrayValue {
            let startTime = result["startTime"].stringValue
            let stopTime = result["stopTime"].stringValue
            let workTime = result["workTime"].stringValue
            
            
            let obj = ["start": startTime, "stop": stopTime,"work":workTime]
            
            datalog.append(obj)
            
            
        }
        
        
        
        update()
        }
    }
    
    
    
    
    func checkIfPumpRunListIsEmpty(json:JSON)->Bool{
        let dialog = DialogViewController()
        print(json["lastRuns"].arrayValue.count)
        if(json["lastRuns"].arrayValue.count<=0){
           dialog.noLogsFoundDialog(type: "activation")
            pumpLabelName.text="No Activations"
            pumpLabelName.textColor = UIColor.white
            pumpLabelName.font = UIFont(name:"SF UI Text", size:21.0)
            
            
            stopLoading()
            return true
        }
        
        print("es false")
        return false
        
    }

    
    func update() {
        
        DispatchQueue.main.async {
            self.engineRunTable.reloadData()
        }
    }
    
    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LastTenEngineRunsTableViewCell = self.engineRunTable.dequeueReusableCell(withIdentifier: "engineruncell") as! LastTenEngineRunsTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        
        stopLoading()
        
        let obj = datalog[(indexPath as NSIndexPath).row]
        
        
        if(pumpType=="1"){
            //Diesel pump
            
            
            pumpIcon.image = UIImage(named:"cuadritodiesel")
            cell.startLabel.text = obj["start"]!
            cell.stopLabel.text =  obj["stop"]!
           let time = Int(obj["work"]!)
            if(time!>=60){
                
                let minutes = time! % 60
                
                let time = time!/60
                
                
                let truetime = String(time)
                
            print("hours")
                print(time)
                print("truetime")
                print(truetime)
                
                cell.opTime.text = time.description+" Hours "+minutes.description+" Minutes"
 
                
                
            }else{
            cell.opTime.text = obj["work"]!+" Minutes"
            }
        }
        if(pumpType=="2"){
            //Electric Pump
            
            pumpIcon.image = UIImage(named:"cuadritoelectrica")
            cell.startLabel.text = obj["start"]!
            cell.stopLabel.text = obj["stop"]!
           
            
            let time = Int(obj["work"]!)
            if(time!>=60){
                
                let minutes = time! % 60
                
                let time = time!/60
                
                
                let truetime = String(time)
                
                print("hours")
                print(time)
                print("truetime")
                print(truetime)
                
                cell.opTime.text = time.description+" Hours "+minutes.description+" Minutes"
                
                
                
            }else{
                cell.opTime.text = obj["work"]!+" Minutes"
            }

            
            
            
       
        
        }
        
        
        
        return cell
        
        
    }
    
    //MARK Action
    
    @IBAction func returnToPumpStatus(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToPumpRuns", sender: self)
        
        
        
        
        
        
    }
    
    
    func stopLoading(){
        loadingText.isHidden=true
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        
        
    }
    
    
    @IBAction func unwindToPumpRuns(segue: UIStoryboardSegue) {}
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "LastTenEngineRunViewController"
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "LastTenEngineRunViewController"
        }

    }

    
    
    
    
}
