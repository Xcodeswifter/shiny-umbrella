//
//  SelectedPumpIssueViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 16/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SelectedPumpIssueViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var pumpLabel: UITextView!
    @IBOutlet weak var selectedPumpIssueTable: UITableView!
    @IBOutlet weak var pumpImage: UIImageView!
    var datalog = [[String: String]]()
    var PumpID:String = ""
    var pumpType:String = ""
    var isMapSelected = false
    var isTrackerMenuSelected = false
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
   //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPumpIssueTable.delegate = self
        selectedPumpIssueTable.dataSource = self
        selectedPumpIssueTable.tableFooterView = UIView(frame: CGRect.zero)
        loadingSpinner.startAnimating()
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        loadPumpIssueData()
      
        
    }
    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
   self.performSegue(withIdentifier: "selectedpumpissuetomap", sender: self)
    
    }
    
    
    
    
    
    func loadPumpIssueData(){
        
        let prefs:UserDefaults = UserDefaults.standard
        let idtracker = prefs.integer(forKey: "IDTRACKER") as Int
        print("load pump issue data")
        print(pumpType)
        print(PumpID)
        if(pumpType=="1"){
            pumpLabel.text = "Diesel Pump"
            pumpLabel.textColor = UIColor.white
            pumpLabel.font = UIFont(name:"SF UI Text", size:21.0)
            
            
            pumpImage.image = UIImage(named: "cuadritodiesel")
        }
        if(pumpType=="2"){
            pumpLabel.text = "Electric Motor"
            pumpLabel.textColor = UIColor.white
            pumpLabel.font = UIFont(name:"SF UI Text", size:21.0)
            

                
                pumpImage.image = UIImage(named: "cuadritoelectrica")
            
        }
        
        print("el id tracker es")
        print(idtracker)
        print("el pump id es")
        print(PumpID)
        let params:[String:AnyObject]=[ "id_tracker": idtracker as AnyObject, "pumpID":PumpID as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumptroubles_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            print(json2)
            self.parseJSON(json2)
            
        })
    }
    
    
    
    //optimized
    func parseJSON(_ json: JSON) {
        
        
        if(!checkIfIssueListIsEmpty(json: json)){
        for result in json["pumpTroubles"].arrayValue {
            let dateTime = result["dateTime"].stringValue
            let statusMessage = result["statusMessage"].stringValue
            let obj = ["dateTime":dateTime, "status":statusMessage]
            datalog.append(obj)
            
            
        }
        
        stopLoading()
        update()
       
        }
    }
    
    
    
    
    func checkIfIssueListIsEmpty(json:JSON)->Bool{
        
        print(json["pumpTroubles"].arrayValue.count)
        if(json["pumpTroubles"].arrayValue.count<=0){
            let alert = UIAlertController(title: "Notice", message: "No alerts history found for this pump.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            pumpLabel.text="No alerts found"
            pumpLabel.textColor = UIColor.white
            pumpLabel.font = UIFont(name:"SF UI Text", size:24.0)

            stopLoading()
            print("es true")
            return true
        }
        
        print("es false")
        return false
        
    }

    
    
    func update() {
        //update your table data here
        
        DispatchQueue.main.async {
            self.selectedPumpIssueTable.reloadData()
        }
    }
    
    
    //MARK- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("datalogcount")
        return datalog.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print(datalog.count)
        
        let cell: SelectedPumpIssueTableViewCell = self.selectedPumpIssueTable.dequeueReusableCell(withIdentifier: "selectedissuecell") as! SelectedPumpIssueTableViewCell
        
        let object = datalog[(indexPath as NSIndexPath).row]
        
        cell.dateTimeText.text = object["dateTime"]
       cell.dateTimeText.textColor = UIColor.white
        
        cell.pumpIssueText.text = object["status"]
        cell.pumpIssueText.textColor = UIColor.white
        cell.pumpIssueText.font = UIFont(name:"SF UI Text", size:18.0)
        

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    // MARK- Actions
    
    @IBAction func returntoMain(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToPumpStatus(segue: UIStoryboardSegue) {}
    @IBAction func unwindToSelectedPumpIssue(segue: UIStoryboardSegue) {}
    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "selectedpumpIssueToSelectTracker", sender: self)

    
    }
    func stopLoading(){
        loadingText.isHidden=true
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        
        
    }
    
    
    
    
    @IBAction func returnToSelectPump(_ sender: Any) {
        self.performSegue(withIdentifier: "pumpStatus", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){
            
            isMapSelected=false
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "SelectedPumpIssueViewController"
            
            
        }
        if(isTrackerMenuSelected){
            isTrackerMenuSelected=false
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "SelectedPumpIssueViewController"
        }

    }
    
}







