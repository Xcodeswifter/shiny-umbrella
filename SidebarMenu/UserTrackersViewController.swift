//
//  UserTrackersViewController.swift
//  
//
//  Created by user on 1/31/17.
//
//

import UIKit
import SwiftyJSON
import Alamofire

class UserTrackersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var userTrackersTable: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!

    @IBOutlet weak var selectTrackerLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    var trackerlist = [[String: Any]]()
    let pushNotificationRequest:AppDelegate = AppDelegate()
    var isMapSelected:Bool = false
    var segueFromController:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        userTrackersTable.delegate = self
        userTrackersTable.dataSource = self
        loadingSpinner.startAnimating()
       // pushNotificationRequest.requestUserPushNotification()//called once
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
            
            stopLoading()
            selectTrackerLabel.text="No connection"
            return false
            
        }
        return true
        
    }
    
    
    func requestTrackerListService(){
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            self.parseJSON(json2)
        })
        
        
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
            
            stopLoading()
            
            return true
        }
        
        return false
        
    }
    
    func update() {
        DispatchQueue.main.async {
            self.loadingSpinner.startAnimating()
            
            self.userTrackersTable.reloadData()
        }
    }
    
    //MARK - Actions
    
    
    
    
    //MARK Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerlist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UsersTrackerTableViewCell = self.userTrackersTable.dequeueReusableCell(withIdentifier: "zeldah") as! UsersTrackerTableViewCell
        
        let object = trackerlist[indexPath.row]
        
        cell.TrackerName?.text = object["Name"] as! String?
        cell.TrackerName.textColor = object["alertedColor"] as! UIColor
        cell.trackerAddress?.text =  object["addressLocation"] as! String?
        cell.trackerAddress?.textColor = object["alertedColor"] as! UIColor
        stopLoading()
        
        return cell
        
    }
    
    //optimized
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseSelectedTrackerAt(indexPath: indexPath)
      
        self.performSegue(withIdentifier: "goToEventReport", sender: self)
        
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
    
    
    @IBAction func unwindToSelectMastersTrackers(segue: UIStoryboardSegue) {}

    
    
    func stopLoading(){
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped=true
        loadingLabel.isHidden=true
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
//            let destination = segue.destination as! AlertsReportViewController
//            destination.segueFromController = "UsersTrackers"
//            
      
        
        
    }
    
    
    
    }
    
  



