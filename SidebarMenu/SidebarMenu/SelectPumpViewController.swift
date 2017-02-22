//
//  SelectPumpViewController
//  GCTRACKV2
// Self-Explanatory
//  Created by Carlos Torres on 9/8/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class SelectPumpViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    var pumplist = [String]()
    var pressurelist = [Int]()
    @IBOutlet weak var pumptable: UITableView!
    //optimized
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pumptable.delegate = self
        pumptable.dataSource = self
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker:Int = prefs.integer(forKey: "IDTRACKER") as Int
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        
        requestCheckPumpService(params: params)
        requestPressureLimitsService(params: params)
        
        
        
    }
    
    
    
    
    func requestCheckPumpService(params:[String:AnyObject]){
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkpump_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
    }
    
    
    
    
    
    func requestPressureLimitsService(params:[String:AnyObject]){
      let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkpressurelimits.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
        
        
        
    }
    
    
    
    
    func parseJSON(_ json: JSON) {
        
        
        let P1 = json["pump01_type"].stringValue
        let P2 = json["pump02_type"].stringValue
        let P3 = json["pump03_type"].stringValue
        let P4 = json["pump04_type"].stringValue
        let P5 = json["pump05_type"].stringValue
        pumplist.append(P1)
        pumplist.append(P2)
        pumplist.append(P3)
        pumplist.append(P4)
        pumplist.append(P5)
        update()
    }
    
    
    //optimized
    
    func parsePressureLimitJSON(_ json: JSON) {
        let activation = json["activation"].intValue
        let lim01 = json["lim01"].intValue
        let lim02 = json["lim02"].intValue
        let lim03 = json["lim03"].intValue
        let lim04 = json["lim04"].intValue
        let lim05 = json["lim05"].intValue
        let pressure=json["pressure"].intValue
        
        //append to the pressureList
        pressurelist.append(activation)
        pressurelist.append(lim01)
        pressurelist.append(lim02)
        pressurelist.append(lim03)
        pressurelist.append(lim04)
        pressurelist.append(lim05)
        pressurelist.append(pressure)
        
        update()
        
    }
    
    
    
    
    func update() {
        //update your table data here
        
        DispatchQueue.main.async {
            self.pumptable.reloadData()
        }
    }
    
    
    
    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pumplist.count
    }
    
    
    
    
    //To optimize this function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: PumpDescriptionTableViewCell = self.pumptable.dequeueReusableCell(withIdentifier: "cell") as! PumpDescriptionTableViewCell
        
        
        let object = pumplist[indexPath.row]
        
        
        if(object == "0"){
            cell.pumpLabel.text="No pumps found for this tracker"
        }
        else{
            if(object == "1"){
                cell.imageView?.image = UIImage(named: "bombadiesel")
                cell.pumpLabel.text="Diesel Pump"
            }
            if(object == "2"){
                cell.imageView?.image = UIImage(named: "bombaelectrica")
                cell.pumpLabel.text="Motor Pump"
            }
            if(object == "3"){
                cell.imageView?.image = UIImage(named: "bombajockey")
                cell.pumpLabel.text="Jockey Pump"
            }
            
        }
        return cell
        
        
        
    }
    
    
    //optimized
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        comparePressureThresholdValues(indexPath: indexPath)
        self.performSegue(withIdentifier: "selectPumpToMain", sender: self)
    }
    
    
    
    
    
    func comparePressureThresholdValues(indexPath:IndexPath){
        
        var pumpTypeid: String = ""
        let pressure = pressurelist[6]
        
        if(pumplist[(indexPath as NSIndexPath).row]=="1"){//diesel pump
            
            
            if case pressurelist[1]...pressurelist[2]-1 = pressure{
                pumpTypeid="dieselpressure1"
            }
            if case pressurelist[2]...pressurelist[3]-1 = pressure{
                pumpTypeid="dieselpressure2"
            }
            if case pressurelist[3]...pressurelist[0] = pressure{
                pumpTypeid="dieselpressure3"
                
            }
            if case pressurelist[4]...pressurelist[5]-1 = pressure{
                pumpTypeid="dieselpressure4"
            }
            if (pressure>=pressurelist[5]){
                pumpTypeid="dieselpressure5"
            }
        }
        if(pumplist[(indexPath as NSIndexPath).row]=="2"){//electric pump
            
            
            if case pressurelist[1]...pressurelist[2]-1 = pressure{
                pumpTypeid="electricpressure1"
                
            }
            if case pressurelist[2]...pressurelist[3]-1 = pressure{
                pumpTypeid="electricpressure2"
                
            }
            if case pressurelist[3]...pressurelist[0] = pressure{
                
                pumpTypeid="electricpressure3"
                
            }
            if case pressurelist[4]...pressurelist[5]-1 = pressure{
                pumpTypeid="electricpressure4"
                
                
                
            }
            if (pressure>=pressurelist[5]){
                pumpTypeid="electricpressure5"
            }
        }
        if(pumplist[(indexPath as NSIndexPath).row]=="3"){//JOCKEY PUMP
            
            
            if case pressurelist[1]...pressurelist[2]-1 = pressure{
                pumpTypeid="jockeypressure1"
            }
            if case pressurelist[2]...pressurelist[3]-1 = pressure{
                pumpTypeid="jockeypressure2"
            }
            if case pressurelist[3]...pressurelist[0] = pressure{
                pumpTypeid="jockeypressure3"
            }
            if case pressurelist[4]...pressurelist[5]-1 = pressure{
                pumpTypeid="jockeypressure4"
            }
            if (pressure>=pressurelist[5]){
                pumpTypeid="jockeypressure5"
            }
        }

        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(pumpTypeid as String, forKey: "PUMPTYPE")
        prefs.synchronize()
    }
    
    
    
    
    // MARK- Actions
    @IBAction func gotomain(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "selectPumpToMain", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ =  segue.destination as! LastTenEngineRunTableViewController
        
    }
    
}
