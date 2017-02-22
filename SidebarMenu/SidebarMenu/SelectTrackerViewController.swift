//
//  SelectTrackerViewController.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 9/20/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SelectTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackerTable: UITableView!
    
    @IBOutlet weak var selectTrackerLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    var trackerlist = [[String: Any]]()
    let pushNotificationRequest:AppDelegate = AppDelegate()
    var isMapSelected:Bool = false
    var segueFromController:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerTable.delegate = self
        trackerTable.dataSource = self
        
        
        if(checkNetworkState()){
           
            //setupDefaultValues()
            requestTrackerListService()
        }
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    //if no tracker is choosen the main screen will show this default values instead, this is in order to prevent crashes
    func setupDefaultValues(){
        let prefs:UserDefaults = UserDefaults.standard
        
        prefs.set(0,  forKey: "IDTRACKER")
        prefs.synchronize()
        prefs.set("Choose a Tracker",  forKey: "NAMEBUSINESS")
        
        
        prefs.synchronize()
        prefs.set("Tracker Address",  forKey: "ADDRESS")
        
        prefs.synchronize()
        
        
        
    }
    
    func checkNetworkState()->Bool{
        _ = DialogViewController()
        if(!NetworkState.isConnectedToNetwork()){
            
            
            showNoInternetDialog()
            
            selectTrackerLabel.text="No connection"
            return false
            
        }
        return true
        
    }
    
    
    func showNoInternetDialog(){
        let alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    
    func requestTrackerListService(){
        let activitiyViewController = ActivityViewController(message: "Logging in...")
        present(activitiyViewController, animated: true, completion: nil)
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            activitiyViewController.dismiss(animated: true, completion: nil)

            self.parseJSON(json2)
        
        
        
        
        })
        
        
    }
    
    
    
    @IBAction func gotomap(_ sender: AnyObject) {
        isMapSelected=true
        self.performSegue(withIdentifier: "gotomap2", sender:self)
        
    }
    
    func parseJSON(_ json: JSON) {
        
        if(!checkIfTrackerListIsEmpty(json: json)){
            for result in json["locations"].arrayValue {
                let address = result["addressLocation"].stringValue
                _ = result["idLocation"].stringValue
                let roomState = result["roomState"].stringValue
                let idTracker = result["idTracker"].stringValue
                let nameBusiness = result["nameLocation"].stringValue
                let alerted = result["alerted"].stringValue
                let alertedColor = UIColor.red
                let notAlertedColor = UIColor.white
                if(alerted=="1"){
                    let obj = ["Name": nameBusiness, "addressLocation": address, "idtracker":idTracker, "alerted":alerted,"alertedColor":alertedColor, "roomState":roomState] as [String : Any]
                    
                    trackerlist.append(obj)
                }
                else{
                    let obj = ["Name": nameBusiness, "addressLocation": address, "idtracker":idTracker, "alerted":alerted, "alertedColor":notAlertedColor, "roomState":roomState] as [String : Any]
                    
                    trackerlist.append(obj )
                }
                
            }
            update()
        }
        
    }
    
    func checkIfTrackerListIsEmpty(json:JSON)->Bool{
        
        print(json["locations"].arrayValue.count)
        if(json["locations"].arrayValue.count<=0){
            
            let dialog = DialogViewController()
            
            dialog.showNoTrackersFoundDialog()
            
            selectTrackerLabel.text="No trackers Found"
            let prefs:UserDefaults = UserDefaults.standard
            
            prefs.set(0,  forKey: "IDTRACKER")
            prefs.synchronize()
            prefs.set("Select tracker",  forKey: "NAMEBUSINESS")
            prefs.synchronize()
            prefs.set("tracker address",  forKey: "ADDRESS")
            
            
            print("es true")
            return true
        }
        
        print("es false")
        return false
        
    }
    
    func update() {
        DispatchQueue.main.async {
            
            self.trackerTable.reloadData()
        }
    }
    
    //MARK - Actions
    
    @IBAction func returntoselectracker(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "returntoselectracker", sender: self)
        
        
    }
    
    @IBAction func gotomap2(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "gotomap2", sender: self)
        
    }
    
    @IBAction func unwindToSelectTracker(segue: UIStoryboardSegue) {}
    
    
    //MARK Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerlist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        _ = UserDefaults.standard
        
        let cell: SelectTrackerTableViewCell = self.trackerTable.dequeueReusableCell(withIdentifier: "zelda") as! SelectTrackerTableViewCell
        
        let object = trackerlist[indexPath.row]
        
        cell.business?.text = object["Name"] as! String?
        cell.business.textColor = object["alertedColor"] as! UIColor
        cell.locationbusiness?.text =  object["addressLocation"] as! String?
        cell.locationbusiness.textColor = object["alertedColor"] as! UIColor
        
        return cell
        
    }
    
    //optimized
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseSelectedTrackerAt(indexPath: indexPath)
        self.performSegue(withIdentifier: "gohome", sender: self)
        
    }
    
    
    
    func chooseSelectedTrackerAt(indexPath:IndexPath){
      
        
        setTrackerDataToPrepareForSegue(indexPath: indexPath as NSIndexPath)
        
        
    
    
    }
    
    
    
    func setTrackerDataToPrepareForSegue(indexPath:NSIndexPath){
        let selectedTracker = trackerlist[(indexPath as NSIndexPath).row]
        
        let prefs:UserDefaults = UserDefaults.standard
        
        prefs.set(selectedTracker["idtracker"],  forKey: "IDTRACKER")
        prefs.synchronize()
        prefs.set(selectedTracker["Name"],  forKey: "NAMEBUSINESS")
        
        
        prefs.synchronize()
        prefs.set(selectedTracker["addressLocation"],  forKey: "ADDRESS")
        
        prefs.synchronize()
        
        
        
        
        
        if(selectedTracker["alerted"] as! String!=="1"){
            
            prefs.set(1,  forKey: "ALERTEDTRACKER")
            prefs.synchronize()
        }
            
        else{
            prefs.set(0,  forKey: "ALERTEDTRACKER")
            prefs.synchronize()
        }
        
        
        if(selectedTracker["roomState"] as! String=="1"){
            prefs.set(1,  forKey: "ROOMSTATE")
            prefs.synchronize()
        }
        else{
            prefs.set(0,  forKey: "ROOMSTATE")
            prefs.synchronize()
        }

        
    }
    
    
       
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
        let destination = segue.destination as! MapViewController
        destination.segueFromController = "SelectTrackerViewController"
        }
        
    }
    
    @IBAction func returnHome(_ sender: UIButton) {
       
        print("unwind segue amigotaa")
        print(segueFromController)
        if segueFromController=="DataLogViewController"{
            print("pressure amigo")
            self.performSegue(withIdentifier: "returnToDataLogFromSelectTracker", sender: nil)
            
        }
        
        
        if segueFromController=="MapViewController"{
            self.performSegue(withIdentifier: "returnToMainScreenFromSelectTracker", sender: self)
            
            
        }
        
        if segueFromController=="MainMenuViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToMainScreenFromSelectTracker", sender: self)
            
        }
        
        if segueFromController=="LastTenDaysPressureTableViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "lastTenDayPressureToSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="PressureViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPressureFromSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="PumpStatusViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpStatusFromSelectTracker", sender: nil)
            
        }
        
        
        
        if segueFromController=="PumpRoomConditionsViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpRoomConditionsFromSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="PumpInfoViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpInfoToSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="LastTenEngineRunViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectPumpRunFromSelectTracker", sender: nil)
            
        }
        
        
        if segueFromController=="SelectPumpRunsViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpRunsFromSelectTracker", sender: nil)
            
        }
        
       
        if segueFromController=="SelectPumpIssuesViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectPumpIssuesViewControllerFromSelectTracker", sender: nil)
            
        }
        
        
        
        if segueFromController=="SelectedPumpIssueViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectedPumpIssueFromSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="DataLogFormViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "backToDataLogFromSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="JockeyPumpViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToJockeyFromSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="SinglePumpStatusViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "singlePumpStatusToSelectTracker", sender: nil)
            
        }
        
        if segueFromController=="SelectFilterViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectFilterFromSelectTracker", sender: nil)
            
        }
        
        
        //
        
        
    }
    
}
