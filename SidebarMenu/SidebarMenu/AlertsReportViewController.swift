//
//  AlertsReportViewController.swift
//  GCTRACKV2BETA
//  Event report screen
//  Created by user on 1/30/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AlertsReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  @IBOutlet weak var alertsReportTable: UITableView!
    
    @IBOutlet weak var companyLabel: UILabel!
    var datalog = [[String: String]]()
    var params:[String:AnyObject] = [:]
    var paramsForFiltering:[String:AnyObject] = [:]
    var isDataFiltered:Bool = false
    var strDate:String=""
    var endDate:String=""
    var pumpSelected1=0
    var pumpSelected2=0
    var pumpSelected3=0
    var isMapSelected:Bool = false
    var segueFromController = ""
    var isTrackerMenuSelected = false
    var idtracker:Int = 0
    
    
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(segueFromController)
        segueFromController = "ReturnBack"
        alertsReportTable.delegate = self
        alertsReportTable.dataSource = self
        alertsReportTable.tableFooterView = UIView(frame: CGRect.zero)
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        print(idtracker)
        params  = [ "id_tracker": idtracker as AnyObject ]
        companyLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        
        
        requestDataLog(params: params)
        
        
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    
    
    func requestDataLog(params:[String:AnyObject]){
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/alertsRPT_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
        
        
    }
    
    
    
   
    
    
    
    
    
    
    
    
    //optimized
    func parseJSON(_ json: JSON) {
        
        
        let dialog = DialogViewController()
        
        if(json["alert"].arrayValue.count<=0){
            
         dialog.showNoEventReportsFoundDialog()
        }else{
                    for result in json["alert"].arrayValue {
                let date = result["id_tracker"].stringValue
                let pressure = result["date"].stringValue
                let status = result["time_broadcast"].stringValue
                let obj = ["id_tracker": date, "date": pressure,"time":status]
                
                datalog.append(obj)
                
                
        }
        
        }
        
            update()
        
    }
    
    
    
    
    func update() {
        //update your table data here
        
        DispatchQueue.main.async {
            self.alertsReportTable.reloadData()
        }
    }
    
    
    func checkIfDatalogIsEmpty(json:JSON)->Bool{
        
        if(json["trackerAlerts"].arrayValue.count<=0){
            
            let dialog = DialogViewController()
            
            dialog.noLogsFoundDialog(type: "incident")
            
            
            
            
            
            return true
            
        }
        return false
        
    }
    
    
    
    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AlertedReportTableViewCell = self.alertsReportTable.dequeueReusableCell(withIdentifier: "cellda") as! AlertedReportTableViewCell
        
        
        let object = datalog[(indexPath as NSIndexPath).row]
        cell.dateLabel.text = " "
        cell.pressureLabel.text =  object["date"]!
        cell.timeBroadcastLabel.text = object["time"]!
        
        return cell
        
        
    }
    
    
    
    @IBAction func unwindToAlertsReport(segue: UIStoryboardSegue) {}

    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    segueFromController = "UsersTrackers"
        let object = datalog[(indexPath as NSIndexPath).row]
        print("cell selected")
        let prefs = UserDefaults.standard
        
        prefs.set(object["time"], forKey: "ATTENDED")
        
        
        self.performSegue(withIdentifier: "alertsToAttended", sender: self)
    }
    
    
    @IBAction func retunrBack(_ sender: Any) {
        
        segueFromController = "ReturnBack"
        self.performSegue(withIdentifier: "returnToMastersTracker", sender: self)

        
    }
   
   
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segueFromController)
        print("POR FAAAAVORR")
        
        
        if(segueFromController=="ReturnBack"){
            let destination = segue.destination as! UserTrackersViewController
            destination.segueFromController = "UsersTrackers"
            
        }
        if(segueFromController=="EventReport"){
        
        
        }
            if(segueFromController=="UsersTrackers"){
            
            let destination = segue.destination as! AttendedAlertViewController
            destination.segueFromController = "AttendedUsersTrackers"
            
   
        }
        
        if(segueFromController=="ReturnBack"){
            let destination = segue.destination as! UserTrackersViewController
            destination.segueFromController = "UsersTrackers"
            
        }

    
    }
    
    
    
    
}
