//
//  PumpStatusViewController.swift
//  GCTRACKV2
//  Class used to show all the status of the pumps
//  Created by Carlos Torres on 9/9/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class PumpStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var pumpStatusLabel: UITextView!
    
    @IBOutlet weak var trackerLabel: UILabel!
    
    @IBOutlet weak var pumpstatustable: UITableView!
    var datalog = [[String: String]]()
    @IBOutlet weak var pumpStatusTitleLabel: UITextView!
    var messagelog = [[String: String]]()
    
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    var idtracker:Int = 0
    var pumpID:String = ""
    var pumpType:String = ""
    var isMapSelected = false
    var isTrackerMenuSelected = false
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pumpstatustable.delegate = self
        pumpstatustable.dataSource = self
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        requestPumpStatusData()
        
        
    }
    
    
    @IBAction func unwindToPumpStatus(segue: UIStoryboardSegue) {}
    
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected=true
        self.performSegue(withIdentifier: "pumpstatustomap", sender: self)
        
    }
    
    func requestPumpStatusData(){
        
        
        let activitiyViewController = ActivityViewController(message: "Loading...")
        present(activitiyViewController, animated: true, completion: nil)

        
        let prefs:UserDefaults = UserDefaults.standard
        idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        
        
        
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumpstatus_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            activitiyViewController.dismiss(animated: true, completion: {
            
            self.parseJSON(json2)})
            
        })
        
        
    }
    
    
    func parseJSON(_ json: JSON) {
        
        if(!checkIfDataLogIsEmpty(json: json)){
            for result in json["pumps"].arrayValue {
                let id = result["pumpID"].stringValue
                let pumpType = result["pumpType"].stringValue
                let statusMessage = result["statusMessage"].stringValue
                let obj = ["pumpID": id, "pumpType": pumpType,"status":statusMessage]
                datalog.append(obj)
                
            }
            
            update()
        }
        
    }
    
    
    func checkIfDataLogIsEmpty(json:JSON)->Bool{
        if(json["pumps"].arrayValue.count<=0){
            
            showErrorMessage()
            
            
            
            
            pumpStatusTitleLabel.text = "No pumps Found"
            self.setTextViewAttributes(pumpStatusLabel: pumpStatusLabel)
            return true
            
        }
        return false
        
    }
    
    func showErrorMessage(){
        let alert = UIAlertController(title: "Pump Status", message: "No pumps found for this tracker", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func update() {
        
        DispatchQueue.main.async {
            self.pumpstatustable.reloadData()
        }
    }
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    
    
    
    //optimized
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: PumpStatusTableViewCell = self.pumpstatustable.dequeueReusableCell(withIdentifier: "cell") as! PumpStatusTableViewCell
        
        
        let object = datalog[(indexPath as NSIndexPath).row]
        
        
        if(!checkIfDataLogContainsOnlyOneElement(object: object, cell:cell)){
            compareCellData(object: object, cell: cell)
        }
        
        
        return cell
    }
    
    
    
    
    
    func compareCellData(object:[String:String],cell:PumpStatusTableViewCell){
        
        if(object["pumpType"]=="1"){
            
            cell.pumpicon.image =  UIImage(named: "cuadritodiesel")
            
            cell.pumpStatusText.text = object["status"]
            setCellTextAttributes(pumpStatusCell: cell)
            
            
            if(object["status"]?.contains("Normal")==false){
                cell.pumpicon.image =  UIImage(named: "cuadritodieselalertado")
                
            }
            else{
                cell.pumpicon.image =  UIImage(named: "cuadritodiesel")
                
            }
            
        }
        if(object["pumpType"]=="2"){
            cell.pumpicon.image =  UIImage(named: "cuadritoelectrica")
            cell.pumpStatusText.text = object["status"]
            setCellTextAttributes(pumpStatusCell: cell)
            if(object["status"]?.contains("Normal")==false){
                cell.pumpicon.image =  UIImage(named: "cuadritoelectricalalertado")
                
            }
            else{
                cell.pumpicon.image =  UIImage(named: "cuadritoelectrica")
                
            }
            
            
        }
        if(object["pumpType"]=="3"){
            cell.pumpicon.image =  UIImage(named: "cuadritojockey")
            cell.pumpStatusText.text = object["status"]
            setCellTextAttributes(pumpStatusCell: cell)
        }
        
        
        
    }
    
    
    
    
    func checkIfDataLogContainsOnlyOneElement(object:[String:String],cell:PumpStatusTableViewCell)->Bool{
        if(datalog.count==1){
            if(object["pumpType"]=="0"){
                print("only one element")
                pumpStatusTitleLabel.text = "No pumps Found"
                setTextViewAttributes(pumpStatusLabel: pumpStatusTitleLabel)
                
                showErrorMessage()
                return true
                
            }
            
        }
        return false
        
    }
    
    //optimized
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkPumpType(indexPath:indexPath)
        
    }
    
    
    
    func setCellTextAttributes(pumpStatusCell: PumpStatusTableViewCell){
        pumpStatusCell.pumpStatusText.textColor = UIColor.white
        pumpStatusCell.pumpStatusText.font = UIFont(name:"SF UI Text", size:18.0)
        
        
    }
    
    func setLabelTextAttributes(textLabel: UILabel){
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont(name:"SF UI Text", size:18.0)
        
        
        
        
    }
    
    
    func checkPumpType(indexPath:IndexPath){
        let object = datalog[(indexPath as NSIndexPath).row]
        let statusMessage = object["status"]! as String
        print()
        
        if(object["pumpType"]=="1"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
            
        }
        
        if(object["pumpType"]=="2"){
            pumpID = object["pumpID"]!
            pumpType = object["pumpType"]!
            
        }
        
        
        
        if(object["pumpType"]=="3"){
            
            
            if(object["pumpID"]=="b4"||object["pumpID"]=="b5"){
                let prefs:UserDefaults = UserDefaults.standard
                
                prefs.set(object["id"],  forKey: "PUMPTYPE")
                prefs.synchronize()
                
            }
            
        }
        
        if(statusMessage.contains("Multiple")){
            
            let prefs:UserDefaults = UserDefaults.standard
            
            prefs.set(object["pumpID"],  forKey: "PUMPID")
            print("el pump id")
            print(object["pumpID"] ?? "pumpid")
            prefs.synchronize()
            prefs.set(object["pumpType"], forKey: "PUMPTYPE")
            prefs.synchronize()
            
            
            self.performSegue(withIdentifier: "goToSinglePumpStatus", sender: self)
            
        }
        
        
    }
    
    // MARK- Actions
    
    @IBAction func returntoMain(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func parseMessage(_ json: JSON) {
        
        for result in json.arrayValue {
            
            let statusMessage = result.stringValue
            let obj = ["status":statusMessage]
            messagelog.append(obj)
        }
        
    }
    
       
    func setTextViewAttributes(pumpStatusLabel:UITextView){
        
        pumpStatusLabel.textColor = UIColor.white
        pumpStatusLabel.font = UIFont(name:"SF UI Text", size:25.0)
        
        
    }
    
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "pumpStatusToSelectTracker", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "PumpStatusViewController"
        }
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "PumpStatusViewController"
        }
        
        
        
        
    }
    
}
