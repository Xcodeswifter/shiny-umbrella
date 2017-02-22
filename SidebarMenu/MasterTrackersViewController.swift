//
//  MasterTrackersViewController.swift
//  GCTRACKV2BETA
//
//  Created by Apple on 07/02/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MasterTrackersViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    //IBOutlets go here
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var mastersTrackerTable: UITableView!
    
    @IBOutlet weak var mastersTrackerLabel: UILabel!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    var trackerlist = [[String: Any]]()
    let pushNotificationRequest:AppDelegate = AppDelegate()
    var isMapSelected:Bool = false
    var segueFromController:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mastersTrackerTable.delegate = self
        mastersTrackerTable.dataSource = self
        pushNotificationRequest.requestUserPushNotification()//called once
        if(checkNetworkState()){
            requestTrackerListService()
        }
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    func checkNetworkState()->Bool{
        _ = DialogViewController()
        if(!NetworkState.isConnectedToNetwork()){
            
            
            showNoInternetDialog()
            
            mastersTrackerLabel.text="No connection"
            return false
            
        }
        return true
        
    }
    
    
    
    
    func showNoInternetDialog(){
        let alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    func requestTrackerListService(){
        
        let activitiyViewController = ActivityViewController(message: "Loading..")
        present(activitiyViewController, animated: true, completion: nil)
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            
            activitiyViewController.dismiss(animated: true, completion: {self.parseJSON(json2)})
        })
        
        
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
            
            mastersTrackerLabel.text="No trackers Found"
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
            
            self.mastersTrackerTable.reloadData()
        }
    }
    
    //MARK - Actions
    
    
    
    
    //MARK Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerlist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        _ = UserDefaults.standard
        
        let cell:MasterTrackerTableViewCell = self.mastersTrackerTable.dequeueReusableCell(withIdentifier: "masterTrackerCell") as! MasterTrackerTableViewCell
        
        let object = trackerlist[indexPath.row]
        
        cell.Business.text = object["Name"] as! String?
        cell.Business.textColor = object["alertedColor"] as! UIColor
        cell.address.text =  object["addressLocation"] as! String?
        cell.address.textColor = object["alertedColor"] as! UIColor
        
        return cell
        
    }
    
    //optimized
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseSelectedTrackerAt(indexPath: indexPath)
        self.performSegue(withIdentifier: "masterTrackersToUserAlert", sender: self)
        
    }
    
    
    
    func chooseSelectedTrackerAt(indexPath:IndexPath){
        
        segueFromController = "Attended Alerts"
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
        
       
    
    }
    
    
    @IBAction func returnToMessages(_ sender: Any) {
        segueFromController = "MasterTrackers"
    self.performSegue(withIdentifier: "backToMessages", sender: self)
    
    }
    
    
    @IBAction func unwindToSelectMastersTrackers(segue: UIStoryboardSegue) {}
    
    
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segueFromController=="Attended Alerts"){
        let destination = segue.destination as! AttendedAlertViewController
        destination.segueFromController = "MasterTrackers"
       
        }
        
        if(segueFromController=="MasterTrackers"){
            
            
            _ = segue.destination as! MessagesViewController
        
    }
    
}

}
