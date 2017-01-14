//
//  DataLogViewController.swift
//  GCTRACKV2
// The table contains logs of the selected tracker
//  Created by Carlos Torres on 9/6/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DataLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterbutton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak  var dataLogTable: UITableView!
    @IBOutlet weak var trackerLabel: UILabel!
    
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
        dataLogTable.delegate = self
        dataLogTable.dataSource = self
        dataLogTable.tableFooterView = UIView(frame: CGRect.zero)
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        params  = [ "id_tracker": idtracker as AnyObject ]
        
       
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        requestDataLog(params: params)

        
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isDataFiltered){
            print("los parametros filtrados")
            print(paramsForFiltering)
            datalog.removeAll()
            update()

            requestFilteredDataLog(params: paramsForFiltering)
        }
    }
    
    
    
    func requestDataLog(params:[String:AnyObject]){
               let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getlog_02-i.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)

        })
        
        
    }
    
    
    func requestFilteredDataLog(params:[String:AnyObject]){
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getlog_02-i.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })

    }
    
    
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected=true
    self.performSegue(withIdentifier: "datalogtomap", sender: self)
    
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //optimized
    func parseJSON(_ json: JSON) {
        if(!checkIfDatalogIsEmpty(json:json)){
        for result in json["trackerAlerts"].arrayValue {
            let date = result["dateTime"].stringValue
            let pressure = result["pressure"].stringValue
            let status = result["statusMessage"].stringValue
            let obj = ["date": date, "pressure": pressure,"status":status]
            
            datalog.append(obj)
            
            
        }
        
        
        
        update()
        }
    }
    
    
    
    
    func update() {
        //update your table data here
        
        DispatchQueue.main.async {
            self.dataLogTable.reloadData()
        }
    }
    
    
    func checkIfDatalogIsEmpty(json:JSON)->Bool{
        
        if(json["trackerAlerts"].arrayValue.count<=0){
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "Data Log",
                                                message: "No incident history found.",
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
            
            filterbutton.isEnabled=false
            sendButton.isEnabled=false
            return true
            
        }
         return false
        
    }
    
    
    
    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DataLoggedTableViewCell = self.dataLogTable.dequeueReusableCell(withIdentifier: "cell") as! DataLoggedTableViewCell
        
        let object = datalog[(indexPath as NSIndexPath).row]
        
        cell.pressureValue?.text = object["pressure"]!
        cell.dateValue?.text =  object["date"]!
        cell.statusLabel?.text = object["status"]!
        
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
        filterbutton.isEnabled=true
        sendButton.isEnabled=true
        
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