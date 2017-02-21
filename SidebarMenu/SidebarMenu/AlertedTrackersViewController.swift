//
//  AlertedTrackersViewController.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 10/19/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AlertedTrackersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var alertedTrackerList = [[String: String]]()
    
    @IBOutlet weak var trackerTable: UITableView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadinglabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        checkNetworkConnection()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNetworkConnection()
        
    }
    
    
    func checkNetworkConnection(){
        if(!NetworkState.isConnectedToNetwork()){
            
            let dialog = DialogViewController()
            
            showNoInternetDialog()
            
            
            loadingSpinner.stopAnimating()
            loadingSpinner.hidesWhenStopped=true
            loadinglabel.text="No internet connection"
        }
        
    }
    
    func showNoInternetDialog(){
        var alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    func loadData(){
        if(!NetworkState.isConnectedToNetwork()){
            
            let dialog = DialogViewController()
            
            showNoInternetDialog()
            
            
            loadingSpinner.stopAnimating()
            loadingSpinner.hidesWhenStopped=true
            loadinglabel.text="No internet connection"
        }
        else{
            loadingSpinner.startAnimating()
            trackerTable.delegate = self
            trackerTable.dataSource = self
            
            let prefs:UserDefaults = UserDefaults.standard
            let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
            
            
            
            
            let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
            
            let handler = AlamoFireRequestHandler()
            handler.processRequest(URL: "https://gct-production.mybluemix.net/getalertedtrackers_02.php" , requestMethod: .post, params: params,completion: { json2 -> () in
                self.parseJSON(json2)
            })
            
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    
    
    
    func parseJSON(_ json: JSON) {
        
        
        
        
        
        for result in json["alertedtrackers"].arrayValue {
            let address = result["address"].stringValue
            
            let idTracker = result["id_tracker"].stringValue
            let nameBusiness = result["name"].stringValue
            let pressure = result["pressure"].stringValue
            let date = result["date"].stringValue
            let obj = ["Name": nameBusiness, "address": address, "idtracker":idTracker,"date":date,"pressure":pressure]
            
            
            alertedTrackerList.append(obj)
            
            
            update()
        }
    }
    
    
    
    func update() {
        
        DispatchQueue.main.async {
            self.trackerTable.reloadData()
        }
    }
    
    
    @IBAction func returntomain(_ sender: Any) {
        
        self.performSegue(withIdentifier: "alertedTrackerToHome", sender: self)
        
    }
    
    //MARK Table Delegates
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertedTrackerList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: AlertedTrackerTableViewCell = self.trackerTable.dequeueReusableCell(withIdentifier: "alertedTrackerCell") as! AlertedTrackerTableViewCell
        
        
        let object = alertedTrackerList[indexPath.row]
        
        if(object["address"]?.isEmpty)!{
            cell.alertedTrackerName.text? = "No trackers found"
            cell.alertedTrackerAddress.text = "No address Found"
            cell.dateAndPressure.text = "Pressure:  not available"
            
        }else{
            cell.alertedTrackerName.text? = object["Name"]!
            cell.alertedTrackerAddress.text = object["address"]
            cell.dateAndPressure.text = "Pressure: "+object["pressure"]!+"  "+object["date"]!
        }
        
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped=true
        loadinglabel.isHidden=true
        
        
        return cell
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTracker = alertedTrackerList[(indexPath as NSIndexPath).row]
        
        let prefs:UserDefaults = UserDefaults.standard
        
        prefs.set(selectedTracker["idtracker"],  forKey: "IDTRACKER")
        prefs.synchronize()
        prefs.set(selectedTracker["Name"],  forKey: "NAMEBUSINESS")
        prefs.set(1,forKey:"ALERTEDTRACKER")
        
        prefs.synchronize()
        prefs.set(selectedTracker["address"],forKey:"ADDRESS")
        prefs.synchronize()
        
        
        
        
        
        self.performSegue(withIdentifier: "alertedTrackerToHome", sender: self)
        
        
    }
    
    
    
    
    
}
