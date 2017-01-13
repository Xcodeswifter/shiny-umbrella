//
//  SinglePumpStatusViewController.swift
//  GCTRACKV2
// Class to show a table of all of the statuses of selected pump(Only the pumps that show multiple issues can be selected)
//  Created by Carlos Torres on 10/27/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SinglePumpStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var singleStatusTable: UITableView!
       var statuslog = [[String: String]]()

    @IBOutlet weak var pumpImage: UIImageView!
    @IBOutlet weak var selectedPumpLabel: UILabel!
    
    var isMapSelected = false
    var isTrackerMenuSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        singleStatusTable.delegate=self
        singleStatusTable.dataSource=self
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        loadData()
        
       
    }

    @IBAction func goToMap(_ sender: Any) {
        isMapSelected = true
    self.performSegue(withIdentifier: "singlePumpStatusToMap", sender: self)
    
    }
   
    func loadData(){
        let prefs = UserDefaults.standard
        let params:[String:AnyObject]=[ "id_tracker": prefs.object(forKey: "IDTRACKER") as AnyObject,"pumpID": prefs.object(forKey: "PUMPID") as AnyObject ]
        print("los parametros")
        print(params)
        
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getsinglepumpstatus_02.php" , requestMethod: .post, params: params,completion: { json2 -> () in
            self.parseJSON(json2)
        })
        
        
        if(prefs.integer(forKey: "PUMPTYPE")==1){
            selectedPumpLabel.text="Diesel Pump"
            pumpImage.image=UIImage(named:"cuadritodiesel")
            
        }
        
        if(prefs.integer(forKey: "PUMPTYPE")==2){
            selectedPumpLabel.text="Electric Motor"
            pumpImage.image=UIImage(named:"cuadritoelectrica")
            
        }

        
    }
    
    
    
    

    //MARK- TableView Methods
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return statuslog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SinglePumpStatusTableViewCell = self.singleStatusTable.dequeueReusableCell(withIdentifier: "singlePumpStatusCell") as! SinglePumpStatusTableViewCell
        
        
        let obj = statuslog[indexPath.row]
        
        cell.singlePumpStatusLabel.text = obj["statusMessages"]! as String
        
        
        
        
        return cell
    }
    
    
    
    
    
    func parseJSON(_ json: JSON) {
        
        
        for result in json["statusMessages"].arrayValue {
            
            let message = result.stringValue
            
            let obj = ["statusMessages":message]

            statuslog.append(obj)
            
            
        }
        
        update()
          }
    

    
    func update() {
        
        
        DispatchQueue.main.async {
            self.singleStatusTable.reloadData()
        }
    }
    
    //MARK- Navigation
    
    
    
    @IBAction func goToPumpStatus(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToPumpStatus", sender: self)
        
        
    }
    
    
    @IBAction func unwindToSinglePumpStatus(segue: UIStoryboardSegue) {}

    
    @IBAction func goToSelectTracker(_ sender: Any) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "singlePumpStatusToSelectTracker", sender: self)
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isMapSelected){

            isMapSelected=false
            if(segue.identifier=="singlePumpStatusToMap"){
            let destination = segue.destination as! MapViewController
            destination.segueFromController = "SinglePumpStatusViewController"
            }
    }
        
        
        if(isTrackerMenuSelected){
            
            
            isTrackerMenuSelected=false
            if(segue.identifier == "singlePumpStatusToSelectTracker"){
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "SinglePumpStatusViewController"
            }
            
            }
            
            

        
        
           }

    
    
    
}
