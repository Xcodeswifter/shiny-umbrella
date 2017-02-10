//
//  ScheduleMaintenanceViewController.swift
//  GCTRACKV2BETA
//
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
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            self.parseJSON(json2)
        })
        
        
    }
    
    
    func parseJSON(_ json: JSON) {
        
        if(!checkIfTrackerListIsEmpty(json: json)){
            for result in json["locations"].arrayValue {
               
                let idTracker = result["idTracker"].stringValue
                let nameBusiness = result["nameLocation"].stringValue
              
                                  let obj = ["Name": nameBusiness,  "idtracker":idTracker] as [String : Any]
                    
                    trackerlist.append(obj as! [String : Any])
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

        cell.isAlarmEnabled.isOn = false
        cell.trackerLabel.text = object["Name"] as! String!
        return cell

        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleMaintenanceTableViewCell
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        
        cell.isAlarmEnabled.setOn(true, animated: true)
        
        let object = trackerlist[indexPath.row]
print("texto")
        print(cell.isAlarmEnabled.isTouchInside)
        setMaintenance(idTracker: object["idtracker"] as! String!, idUser:iduser , checkbox: cell.isAlarmEnabled.isOn)
   
    
    
    }
    
    
    
    
    
    func setMaintenance(idTracker:String,idUser:Int, checkbox:Bool){
        
        var checkboxState = 0
        if(checkbox){
            checkboxState=1
        }
        
        
        let params:[String:AnyObject]=[ "id_user": idUser as AnyObject, "id_tracker":idTracker as AnyObject, "active":checkboxState as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/setmaintenancepush.php", requestMethod: .post, params: params,completion: { json2 -> () in
print(json2)
        
        })
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
