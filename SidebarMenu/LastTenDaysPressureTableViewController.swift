//
//  LastTenDaysPressureTableViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 08/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RNGridMenu

class LastTenDaysPressureTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,RNGridMenuDelegate{
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var trackerLabel: UILabel!
    
    @IBOutlet weak var dataLogPressureHistoryText: UITextView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var pressurePumpHistoryTable: UITableView!
    var isMapSelected = false
    var datalog = [[String: String]]()
    var menu:RNGridMenu?
    
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        pressurePumpHistoryTable.delegate=self
        pressurePumpHistoryTable.dataSource=self
        loadingSpinner.startAnimating()
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        
        loadData()
    }
    
    
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected=true
   self.performSegue(withIdentifier: "pressurelogtomap", sender: self)
    
    }
    
    
    @IBAction func unwindToLastTenDayPressure(segue: UIStoryboardSegue) {}

    
    
    func loadData(){
        
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        
        
        let  params  = [ "id_tracker": idtracker as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getlastpressures_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
            
        })
        
        
    }
    
   
    
    
    
    func parseJSON(_ json: JSON) {
        
        
        if(!checkIfDataLogIsEmpty(json: json)){
        for result in json["lastPressures"].arrayValue {
            let date = result["dateTime"].stringValue
            let pressure = result["pressure"].stringValue
            let obj = ["dateTime": date, "pressure": pressure]
            
            datalog.append(obj)
            
            
        }
        
        
        update()
        }
    }
    
    
    
    func checkIfDataLogIsEmpty(json:JSON)->Bool{
        let dialog = DialogViewController()
       
        if(json["lastPressures"].arrayValue.count<=0){
           
            dialog.noLogsFoundDialog(type: "pressure")
            stopLoading()
            dataLogPressureHistoryText.text = "No pressure data"
            setTextViewAttributes(pressureHistoryText: dataLogPressureHistoryText)
            return true
            
        }
        return false
        
    }

    
    
    func update() {
        
        DispatchQueue.main.async {
            self.pressurePumpHistoryTable.reloadData()
        }
    }
    
    
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        
        let cell: LastTenDaysPressureTableViewCell = self.pressurePumpHistoryTable.dequeueReusableCell(withIdentifier: "pressurehistorycell") as! LastTenDaysPressureTableViewCell
        stopLoading()
        
        let object = datalog[(indexPath as NSIndexPath).row]
        let dateTimeSplitText = object["dateTime"]!.characters.split{$0 == " "}.map(String.init)
        
        
        cell.pressureLabel.text? = object["pressure"]!
        
        cell.dateTimeText.text = dateTimeSplitText[0]+"\n"+dateTimeSplitText[1]
        
        
        
        cell.dateTimeText.textColor = UIColor.white
        
        return cell
        
        
    }
    
    
    
    func stopLoading(){
        loadingText.isHidden=true
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        
        
    }
    
    
    
    
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToSelectFilter", sender: self)
    }
    
    
    @IBAction func showJockeyPumpStatus(_ sender: Any) {
        menu?.delegate = self
        menu = RNGridMenu(titles:["Jockey Pump 10 days", "8 Times"] )
        menu?.itemSize.height=300
        menu?.itemSize.width=300
        menu?.itemFont = UIFont(name:"SF UI Text", size:28.0)
        

        
        menu?.show(in:self , center:CGPoint.init(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2))
        
        
        
        
    }
    
    
    
    func setTextViewAttributes(pressureHistoryText:UITextView){
        
        pressureHistoryText.textColor = UIColor.white
        pressureHistoryText.font = UIFont(name:"SF UI Text", size:25.0)
        
        
    }
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "pressureLogToSelectTracker", sender: self)

    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "LastTenDaysPressureTableViewController"
        }
        
        
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "LastTenDaysPressureTableViewController"
        }

    }

    
    
}
