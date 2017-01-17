//
//  MessagesViewController.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messagesTable: UITableView!
    var json2:JSON = ["locations":[["idLocation":"300","addressLocation":"mario","nameLocation":"error en la bomba","latitudeLocation":"arregla la bomba men ","longitudeLocation":"-115.375343","idTracker":"500500","alerted":1,"roomState":0],["idLocation":"300","addressLocation":"Prueba de la tabla","nameLocation":"error en la bomba","latitudeLocation":"falla en la jockey men ","longitudeLocation":"-115.375343","idTracker":"500500","alerted":1,"roomState":0]]]
    var messagelist = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        parseJSON(json2)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    func parseJSON(_ json: JSON) {
        
        for result in json["locations"].arrayValue {
            let address = result["addressLocation"].stringValue
            let idlocation = result["idLocation"].stringValue
            let roomState = result["roomState"].stringValue
            let idTracker = result["idTracker"].stringValue
            let nameBusiness = result["nameLocation"].stringValue
            let alerted = result["alerted"].stringValue
            let alertedColor = UIColor.red
            let notAlertedColor = UIColor.white
            if(alerted=="1"){
                let obj = ["Name": nameBusiness, "addressLocation": address, "idtracker":idTracker, "alerted":alerted,"alertedColor":alertedColor, "roomState":roomState] as [String : Any]
                
                messagelist.append(obj)
            }
            else{
                let obj = ["Name": nameBusiness, "addressLocation": address, "idtracker":idTracker, "alerted":alerted, "alertedColor":notAlertedColor, "roomState":roomState] as [String : Any]
                
                messagelist.append(obj as! [String : Any])
                
            }
        }
        update()
        
        
        
        
        
        
    }
    
    
    
    func update() {
        DispatchQueue.main.async {
            
            self.messagesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagelist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prefs:UserDefaults = UserDefaults.standard
        
        let cell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell
        
        let object = messagelist[indexPath.row]
        
        cell.titleLabel.text = object["Name"] as! String?
        cell.subjectLabel.text = "Falla grave"
        cell.theDateLabel.text =  "12/ene/2017"
        cell.bodyLabel.text = object["addressLocation"] as! String?
        
        return cell
        
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    

  

}
