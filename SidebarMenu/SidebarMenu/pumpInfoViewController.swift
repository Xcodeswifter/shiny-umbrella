//
//  pumpInfoViewController.swift
//  GCTRACKV2
//  Describes the specs of the pumps of the selected tracker
//  Created by Carlos Torres on 10/11/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class pumpInfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var systemInfoTitleLabel: UITextView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    
    @IBOutlet weak var systemInfoTable: UITableView!
    var pumplist = [[String: Any]]()
    
    @IBOutlet weak var systemInfoData: UITextView!
    @IBOutlet weak var systemInfoText: UITextView!
    var isMapSelected = false
    var isTrackerMenuSelected = false
    //to optimize this function
    override func viewDidLoad() {
        super.viewDidLoad()
        systemInfoTable.delegate=self
        systemInfoTable.dataSource=self
        systemInfoTable.tableFooterView = UIView(frame: CGRect.zero)
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        loadSystemInfoData()
        
    }
    
    
    func loadSystemInfoData(){
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)
        let prefs:UserDefaults = UserDefaults.standard
        let  idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        let  params  = [ "id_tracker": idtracker as AnyObject ]
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getinfo_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            activitiyViewController.dismiss(animated: true, completion: { self.parseJson(json: json2)
                print("mira aqui la info de la bomba amigo ")
                print(json2["systemInfo"].stringValue)
                self.systemInfoData.text = "System info:  "+"\n"+json2["systemInfo"].stringValue
                self.setSystemInfoTextAttributes(textView: self.systemInfoData)})
           
                        
            
        })
        
        
        
        
    }
    
    
    
    @IBOutlet weak var goback: UIButton!
    
    @IBAction func goback(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "returntoDashboard", sender: self)
        
    }
    
    
    
    //optimized
    func parseJson(json:JSON){
        
        
        if(!checkifPumpInfoIsEmpty(json: json)){
            checkPump01Type(json: json)
            checkPump02Type(json: json)
            checkPump03Type(json: json)
            checkPump04Type(json: json)
            checkPump05Type(json: json)
            update()
            
        }else{
            showMessage()
            
        }
    }
    
    
    
    func showMessage(){
       let dialog = DialogViewController()
        dialog.noLogsFoundDialog(type: "pumps")
   systemInfoTitleLabel.text = "No Info Found"
        self.setTitleTextAttributes(textView: systemInfoTitleLabel)
    
    }
    
    
    
    
    
    func update() {
        //update your table data here
        DispatchQueue.main.async {
            self.systemInfoTable.reloadData()
        }
    }
    
    @IBAction func goToMap(_ sender: Any) {
   isMapSelected = true
        self.performSegue(withIdentifier:"infotomap", sender: self)
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pumplist.count
    }
    
    
    
       
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: SystemInfoTableViewCell = self.systemInfoTable.dequeueReusableCell(withIdentifier: "systemInfoCell") as! SystemInfoTableViewCell
        
        let object = pumplist[indexPath.row]
        
        print("PUMPLIST COUNT")
        print(pumplist.count)
        print("el object nenne")
        print(object)
        if(object["pumpInfo"]as! String?==""){
        print("it works")
            cell.pumpLabel.text = object["pumpType"] as! String?
            cell.pumpLabel.textColor = object["textColor"] as! UIColor!
            
        }else{
            
            cell.pumpLabel.text = object["pumpType"] as! String?
            cell.pumpLabel.textColor = object["textColor"] as! UIColor!
            
            cell.pumpDescription? .text = object["pumpInfo"] as! String?
        }
        
        return cell
        
        
        
        
        
    }
    
    
    
    
    
    
    //MARK other functions
    
    
    
    func checkifPumpInfoIsEmpty(json:JSON)->Bool{
        
        
        if(json["pump01Info"].stringValue.isEmpty&&json["pump02Info"].stringValue.isEmpty&&json["pump03Info"].stringValue.isEmpty&&json["pump04Info"].stringValue.isEmpty&&json["pump05Info"].stringValue.isEmpty){
           return true
            
        }
        
        return false
    }
    
    
    
    func checkPump01Type(json:JSON){
        if(json["pump01Type"]==1){
            if(!json["pump01Info"].stringValue.isEmpty){
                print("not empty")
            let obj = ["pumpType": "Diesel Pump Info", "pumpInfo": json["pump01Info"].stringValue, "textColor":UIColor.orange] as [String : Any]
            
            pumplist.append(obj)
            }
        }
        if(json["pump01Type"]==2){
            print("not empty")

             if(!json["pump01Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Electric Pump Info", "pumpInfo": json["pump01Info"].stringValue, "textColor":UIColor.cyan] as [String : Any]
            
            pumplist.append(obj)
            
            }
        }
        if(json["pump01Type"]==3){
            print("not empty")

             if(!json["pump01Info"].stringValue.isEmpty){
            
            let obj = ["pumpType": "Jockey Pump Info", "pumpInfo": json["pump01Info"].stringValue, "textColor":UIColor.green] as [String : Any]
            
            pumplist.append(obj)
            
            }
            
        }
        
        
        
    }
    
    func checkPump02Type(json:JSON){
        if(json["pump02Type"]==1){
            print("not empty")

             if(!json["pump02Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Diesel Pump Info", "pumpInfo": json["pump02Info"].stringValue, "textColor":UIColor.orange] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        if(json["pump02Type"]==2){
            print("not empty")

             if(!json["pump02Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Electric Pump Info", "pumpInfo": json["pump02Info"].stringValue, "textColor":UIColor.cyan] as [String : Any]
            
            pumplist.append(obj)
            
            }
        }
        
        if(json["pump02Type"]==3){
            print("not empty")

             if(!json["pump02Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Jockey Pump Info", "pumpInfo": json["pump02Info"].stringValue, "textColor":UIColor.green] as [String : Any]
            
            pumplist.append(obj)
            }
        }
        
        
    }
    
    
    
    func checkPump03Type(json:JSON){
        
        
        
        if(json["pump03Type"]==1){

             if(!json["pump03Info"].stringValue.isEmpty){
                print("not empty")

            let obj = ["pumpType": "Diesel Pump Info", "pumpInfo": json["pump03Info"].stringValue, "textColor":UIColor.orange] as [String : Any]
            
            pumplist.append(obj)
            }
        }
        if(json["pump03Type"]==2){

             if(!json["pump03Info"].stringValue.isEmpty){
                
            let obj = ["pumpType": "Electric Pump Info", "pumpInfo": json["pump03Info"].stringValue, "textColor":UIColor.cyan] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        if(json["pump03Type"]==3){
            print("not empty")

             if(!json["pump03Info"].stringValue.isEmpty){
           
                
                let obj = ["pumpType": "Jockey Pump Info", "pumpInfo": json["pump03Info"].stringValue, "textColor":UIColor.green] as [String : Any]
            
            pumplist.append(obj)
            }
            
            
        }
        
    }
    
    
    
    func checkPump04Type(json:JSON){
        
        if(json["pump04Type"]==1){
           
            print("not empty")

            if(!json["pump04Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Diesel Pump Info", "pumpInfo": json["pump04Info"].stringValue, "textColor":UIColor.orange] as [String : Any]
            
            pumplist.append(obj)
            }
        }
        if(json["pump04Type"]==2){
            print("not empty")

             if(!json["pump04Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Electric Pump Info", "pumpInfo": json["pump04Info"].stringValue, "textColor":UIColor.cyan] as [String : Any]
            
            pumplist.append(obj)
            }
        }
        if(json["pump04Type"]==3){
            print("not empty")

             if(!json["pump04Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Jockey Pump Info", "pumpInfo": json["pump04Info"].stringValue, "textColor":UIColor.green] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        
        
        
    }
    
    func checkPump05Type(json:JSON){
        if(json["pump05Type"]==1){
            print("not empty")

             if(!json["pump05Info"].stringValue.isEmpty){
            let obj = ["pumpType": "Diesel Pump Info", "pumpInfo": json["pump05Info"].stringValue, "textColor":UIColor.orange] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        if(json["pump05Type"]==2){
            print("not empty")

             if(!json["pump05Type"].stringValue.isEmpty){
            let obj = ["pumpType": "Electric Pump Info", "pumpInfo": json["pump05Info"].stringValue, "textColor":UIColor.cyan] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        if(json["pump05Type"]==3){
            print("not empty")

            if(!json["pump05Type"].stringValue.isEmpty){
            let obj = ["pumpType": "Jockey Pump Info", "pumpInfo": json["pump05Info"].stringValue, "textColor":UIColor.green] as [String : Any]
            
            pumplist.append(obj)
            }
            
        }
        
        
    }
    
    
    
    
    func setSystemInfoTextAttributes(textView:UITextView){
        
        textView.textColor = UIColor.red
        textView.font = UIFont(name:"SF UI Text", size:14.0)
        
    }
    
    func setTitleTextAttributes(textView:UITextView){
        
        textView.textColor = UIColor.white
        textView.font = UIFont(name:"SF UI Text", size:24.0)
        
    }
    
    
    @IBAction func unwindToPumpInfo(segue: UIStoryboardSegue) {}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "PumpInfoViewController"
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "PumpInfoViewController"
        }

        
        
        
    }


    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "pumpInfoToSelectTracker", sender: self)

    
    
    }
    
}
