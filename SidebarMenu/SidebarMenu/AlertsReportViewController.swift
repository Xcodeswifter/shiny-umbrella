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
    
    var isTrackerMenuSelected = false
    var idtracker:Int = 0
    
    
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        alertsReportTable.delegate = self
        alertsReportTable.dataSource = self
        alertsReportTable.tableFooterView = UIView(frame: CGRect.zero)
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        params  = [ "id_tracker": idtracker as AnyObject ]
        
        
        
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
    
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected=true
        self.performSegue(withIdentifier: "datalogtomap", sender: self)
        
    }
    
    
    
    
    
    
    
    
    
    //optimized
    func parseJSON(_ json: JSON) {
                    for result in json["alert"].arrayValue {
                let date = result["id_tracker"].stringValue
                let pressure = result["date"].stringValue
                let status = result["time_broadcast"].stringValue
                let obj = ["id_tracker": date, "date": pressure,"time":status]
                
                datalog.append(obj)
                
                
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
        print(datalog.count)
        cell.dateLabel.text = " "
        cell.pressureLabel.text =  object["date"]!
        cell.timeBroadcastLabel.text = object["time"]!
        
        return cell
        
        
    }
    
    
    
    
    //MARK- Action
    
    @IBAction func returnToMain(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "returnToSelectFilter", sender: self)
    }
    @IBAction func goToSendForm(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sendForm", sender: self)
        
    }
    
    
    
    //optimized
    @IBAction func reset(_ sender: AnyObject) {
        
        datalog.removeAll()
        update()
        requestDataLog(params: [ "id_tracker": idtracker as AnyObject ])
                
    }
    
    //optimized
    @IBAction func sendEmail(_ sender: AnyObject) {
        showSendEmailDialog()
        
    }
    
    
    
    
    
    func showSendEmailDialog(){
        var alertController:UIAlertController
        var email:String=""
        let prefs:UserDefaults = UserDefaults.standard
        
        let idUser = prefs.integer(forKey: "IDUSER") as Int
        
        
        
        
        
        
        //Create the alert controller screen
        
        
        alertController = UIAlertController(title: "Enter Email",
                                            message: "Please enter the email ",
                                            preferredStyle: .alert)
        
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter email address"
        })
        
        
        
        
        
        //Send action handler
        alertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default,handler: {
            (alert: UIAlertAction!) in
            
            email=(alertController.textFields?.first?.text)!
            let  params  = [ "id_tracker": self.idtracker as AnyObject, "email_address":email, "id_user":idUser,"end_date":self.endDate,"start_date":self.strDate, "pump01":self.pumpSelected1,"pump02":self.pumpSelected2,"pump03":self.pumpSelected3] as [String : Any]
            
            self.requestEmailService(params:params)
            
            
            
            
        }))
        
        
        //cancel Action Handler
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {
            (alert: UIAlertAction!) in
            print("you have canceled the email action")
        }))
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
        
    }
    
    
    
    func requestEmailService(params:[String:Any]){
        
        
        print("params")
        print(params)
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/sendreport_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            if(json2["mailSent"]==1){
                var alertController:UIAlertController?
                alertController = UIAlertController(title: "Email",
                                                    message: "Mail Sent",
                                                    preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK",
                                           style: UIAlertActionStyle.default,
                                           handler: {[weak self]
                                            (paramAction:UIAlertAction!) in
                                            
                })
                
                alertController?.addAction(action)
                self.present(alertController!,
                             animated: true,
                             completion: nil)
            }
        })
        
        
        
    }
    
    
    
    @IBAction func unwindToDataLog(segue: UIStoryboardSegue) {}
    
    
    
    @IBAction func goToMainScreen(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "exitToMain", sender: self)
    }
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "dataLogToSelectTracker", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "DataLogViewController"
        }
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "DataLogViewController"
        }
        
    }


    
    
    
    
}
