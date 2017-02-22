//
//  GeneralAlarmsTableViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 08/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class GeneralAlarmsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var generalAlarmTable: UITableView!
    var datalog = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
    generalAlarmTable.delegate=self
        generalAlarmTable.dataSource=self
      let prefs  = UserDefaults.standard
        let idtracker = prefs.integer(forKey: "IDTRACKER") as Int

        
        let   params  = [ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumptroubles_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })

        
    }

    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GeneralAlarmsTableViewCell = self.generalAlarmTable.dequeueReusableCell(withIdentifier: "generalalarmscell") as! GeneralAlarmsTableViewCell
        
        let object = datalog[(indexPath as NSIndexPath).row]
        
        
        if(object["pumptype"]=="1"){
            cell.imageLabel.image = UIImage(named: "cuadritodiesel")
            cell.dateLabel.text? = object["date"]!
            cell.statusLabel.text = object["status"]
            cell.timeLabel.text? = ""

        }
        if(object["pumptype"]=="2"){
            cell.imageLabel.image = UIImage(named: "cuadritoelectrica")
            cell.dateLabel.text? = object["date"]!
            cell.statusLabel.text = object["status"]
            cell.timeLabel.text? = ""

        }
        if(object["pumptype"]=="3"){
            cell.imageLabel.image = UIImage(named: "cuadritojockey")
            cell.dateLabel.text? = object["date"]!
            cell.statusLabel.text = object["status"]
            cell.timeLabel.text? = ""

        }
        

        
        
               return cell
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        let object = datalog[(indexPath as NSIndexPath).row]
        _ = object["status"]! as String
        
        if(object["pumpType"]=="3"){
            
            
            self.performSegue(withIdentifier: "pumpRunsToJockey", sender: self)
            
        }
        
        
        
            
        

    
    
    
    
    
    
    }
    
    func parseJSON(_ json: JSON) {
        
        for result in json["pumpTroubles"].arrayValue {
            let date = result["dateTime"].stringValue
            let pumpType = result["pumpType"].stringValue
            let status = result["statusMessage"].stringValue
            let obj = ["date": date, "pumptype": pumpType,"status":status]
            
            datalog.append(obj)
            
            
        }

        
        
        
        update()
        
    }
    
    
    
    
    func update() {
        //update your table data here
        
        DispatchQueue.main.async {
            self.generalAlarmTable.reloadData()
        }
    }
    
    

    
    
    //Mark Actions
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToSelectFilter", sender: self)

        
    }
    
    
    
    
}
