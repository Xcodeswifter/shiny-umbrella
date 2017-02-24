//
//  ScheduleMaintenanceViewController.swift
//  GCTRACKV2BETA
//Class used for schedule maintenance notificactions in 7, 15, and 30 day intervals
//  Created by Apple on 09/02/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ScheduleMaintenanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var alarmsTable: UITableView!
    var trackerlist = [[String: Any]]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        alarmsTable.delegate = self
        alarmsTable.dataSource = self
        
       

        requestMasterUserTrackers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func requestMasterUserTrackers(){
        
        
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)

        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            activitiyViewController.dismiss(animated: true, completion: { self.parseJSON(json2)
})
            
        
        
        })
        
        
    }
    
    
    func parseJSON(_ json: JSON) {
        
        if(!checkIfTrackerListIsEmpty(json: json)){
            for result in json["locations"].arrayValue {
               
                let idTracker = result["idTracker"].stringValue
                let nameBusiness = result["nameLocation"].stringValue
                let maintenance_push = result["maintenance_push"].intValue
              
                print("estatus")
                print(maintenance_push)
                if(maintenance_push==0){
                let obj = ["Name": nameBusiness,  "idtracker":idTracker, "maintenance":false ] as [String : Any]
                    
                    trackerlist.append(obj as! [String : Any])
                }
                
                
                
                if(maintenance_push==1){
                    let obj = ["Name": nameBusiness,  "idtracker":idTracker, "maintenance":true] as [String : Any]
                    
                    trackerlist.append(obj as! [String : Any])
                }
                
                
            }
                
                
            }
            update()
        
        
        
    }

    
    
    
    func update() {
        DispatchQueue.main.async {
            
            self.alarmsTable.reloadData()
        }
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

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerlist.count
    }
    
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ScheduleMaintenanceTableViewCell = self.alarmsTable.dequeueReusableCell(withIdentifier: "scheduleMaintenanceCell") as! ScheduleMaintenanceTableViewCell

    
    
        let object = trackerlist[indexPath.row]

        cell.isAlarmEnabled.isOn = object["maintenance"] as! Bool!
        cell.trackerLabel.text = object["Name"] as! String!
        return cell

        
        
    }
    
    
    
    
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleMaintenanceTableViewCell
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        var isChecked = UserDefaults.standard
        
        
        cell.isAlarmEnabled.tag = indexPath.row
        isChecked.set(indexPath.row, forKey: "ROW")
        isChecked.synchronize()
        cell.isAlarmEnabled.addTarget(self, action: Selector("tapSwitch"), for: .touchUpInside)
        
        
        if(cell.isAlarmEnabled.isOn){//Switch is on
            isChecked.set(0, forKey: "CHECKED")
            isChecked.synchronize()
            
            
        cell.isAlarmEnabled.setOn(false, animated: true)
        }
        else{//Switch is off
            isChecked.set(1, forKey: "CHECKED")
            isChecked.synchronize()

            cell.isAlarmEnabled.setOn(true, animated: true)
 
        }
        
        let object = trackerlist[indexPath.row]
        print(object["idtracker"] as! String!)
        setMaintenance(idTracker: object["idtracker"] as! String!, idUser:iduser , checkbox: isChecked.integer(forKey: "CHECKED"))
   
    
    
    }
    
    
    func tapSwitch(){
        print("touch up inside de tap switch")
        let currentPosition = UserDefaults.standard
        
        let object = trackerlist[currentPosition.integer(forKey: "ROW")]
        let iduser:Int = currentPosition.integer(forKey: "IDUSER") as Int
        setMaintenance(idTracker: object["idtracker"] as! String!, idUser:iduser , checkbox: currentPosition.integer(forKey: "CHECKED"))

        
        
    }
    
    
    
    func setMaintenance(idTracker:String,idUser:Int, checkbox:Int){
        let activitiyViewController = ActivityViewController(message: "Please wait...")
        present(activitiyViewController, animated: true, completion: nil)

        print("checkbox")
        print(checkbox)
        let params:[String:AnyObject]=[ "id_user": idUser as AnyObject, "id_tracker":idTracker as AnyObject, "active":checkbox as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/setmaintenancepush.php", requestMethod: .post, params: params,completion: { json2 -> () in
            print("check status")
            
            print(json2)
        activitiyViewController.dismiss(animated: true, completion: nil)
        })
        
        
    }
    
    
}
