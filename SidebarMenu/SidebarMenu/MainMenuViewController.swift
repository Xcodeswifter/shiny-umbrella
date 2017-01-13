//
//  MainMenuViewController.swift
//  GCTRACKV2
// Class to represent the main screen of the app, where the user can go to any other parts of the app, it must not be confused with MainScreenController
//  Created by Carlos Torres on 9/3/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainMenuViewController: UIViewController, UITextFieldDelegate,UIActionSheetDelegate{
    
    @IBOutlet weak var maintenanceButton: UIButton!
    @IBOutlet weak var roomStateIcon: UIButton!
    @IBOutlet weak var trackerAddressButton: UIButton!
    @IBOutlet weak var selectPumpButton: UIButton!
    @IBOutlet weak var alertedTrackerButton: UIButton!
    @IBOutlet weak var trackerChooserButton: UIButton!
    var pumplist=[String]()
    var idUser:Int = 0
    var NameBusiness:String?=""
    var pumpType:String = ""
    var accepted:Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedTracker: String = ""
var isTrackerMenuSelected = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did load")
    stopAlarm()
        UIApplication.shared.applicationIconBadgeNumber = 0
        checkForAlertedTrackers()
        loadData()
        
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
       stopAlarm()
       checkForAlertedTrackers()
        loadData()
        
    }
    
    
    func stopAlarm(){
        let sound = AlarmSound()
        sound.stopSounds()
        
        
    }
    
    
    //TO OPTIMIZE THIS FUNCTION
    func loadData(){
   
        let prefs:UserDefaults = UserDefaults.standard
        
        idUser = prefs.integer(forKey: "IDUSER") as Int
        
        accepted = prefs.integer(forKey: "ACCEPTED")
        print(idUser)
        print(accepted)
        
        
        if (idUser <= 0) {
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        
        if (accepted<1) {
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        
        
        
        if(!NetworkState.isConnectedToNetwork()){
            let alert = UIAlertController(title: "Notice", message: "Check you internet connection  ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            trackerChooserButton.setTitle("No internet connection", for: .normal)
            print("desconectado")
            
            
            
            
        }
            
         
            
        if(prefs.integer(forKey: "TIMEUP")==1){
            let buttonImage = UIImage(named: "maintenance")
            
        }
        if(prefs.integer(forKey: "ENABLED")==0){
            let buttonImage = UIImage(named: "maintenance")
            prefs.set(0, forKey: "TIMEUP")

        }
        if(prefs.integer(forKey: "ENABLED")==1){
            let buttonImage = UIImage(named: "maintenancered")
            
        }
        
            
            
            
            
            
            
        else{
            
            let prefs:UserDefaults = UserDefaults.standard
            NameBusiness = prefs.object(forKey: "NAMEBUSINESS") as! String?
            idUser = prefs.integer(forKey: "IDUSER") as Int
            
            accepted = prefs.integer(forKey: "ACCEPTED")
            print(prefs.object(forKey: "IDTRACKER"))
            print(prefs.object(forKey: "ADDRESS"))
            print(prefs.object(forKey: "NAMEBUSINESS"))
            
            trackerChooserButton.setTitle(NameBusiness, for: .normal)
            trackerAddressButton.setTitle( prefs.object(forKey: "ADDRESS") as! String?, for: .normal)
            
            
            
            
            
            if (idUser <= 0) {
                self.performSegue(withIdentifier: "logout", sender: self)
            }
            
            if (accepted<1) {
                self.performSegue(withIdentifier: "logout", sender: self)
            } else {
                
            }
            
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.idUser=idUser
            
            
            let params=["id_user":idUser]
            
            let handler = AlamoFireRequestHandler()
            handler.processRequest(URL: "https://gct-production.mybluemix.net/checkifalerted_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
                if(json2["alerted"].intValue==1) {
                    self.alertedTrackerButton.setImage(UIImage(named: "menu icono amarillo"), for: [])
                    self.alertedTrackerButton.isEnabled=true
                }
                    
                else {
                    self.alertedTrackerButton.setImage(UIImage(named: "menu icono "), for: [])
                    self.alertedTrackerButton.isEnabled=false
                    let buttonImage = UIImage(named: "iconopumpstatus_HDPI")
                    self.selectPumpButton.setImage(buttonImage, for: [])
                }
                
            })
            
            
            let isAlertedTracker = prefs.object(forKey: "ALERTEDTRACKER") as? Int
            if (isAlertedTracker==1){
                
                let buttonImage = UIImage(named: "iconoselectpump_rojo")
                self.selectPumpButton.setImage(buttonImage, for: [])
                
                
            }
            else{
                let buttonImage = UIImage(named: "iconopumpstatus_HDPI")
                self.selectPumpButton.setImage(buttonImage, for: [])
                
            }
            
            let roomState = prefs.object(forKey: "ROOMSTATE") as? Int
           print("el room state")
            print(roomState)
            if (roomState==1){
                print("se seteo en rojo")
                let buttonImage = UIImage(named: "roomRojo")
                self.roomStateIcon.setImage(buttonImage, for: [])
                
                
            }
            else{
                let buttonImage = UIImage(named: "termometro 300x300")
                self.roomStateIcon.setImage(buttonImage, for: [])
                
            }
            

            
            
            
        }
        
    
    }
    
    
    
    
    
    func checkForAlertedTrackers(){
        let prefs:UserDefaults = UserDefaults.standard
    let alerted = prefs.object(forKey: "ALERTEDTRACKER") as! Int?
        if(alerted==1){
            
            requestedAlertedTrackers()
            
        }
        else{
            selectedTracker = "Select Tracker"
            NameBusiness = "Address"
            //prefs.set(0, forKey: "IDTRACKER")
            
        }
        
        
        
        
    }
    
    
    func requestedAlertedTrackers(){
        
        
        let prefs:UserDefaults = UserDefaults.standard
        let params:[String:AnyObject]=[ "id_user": prefs.object(forKey: "IDUSER") as AnyObject ]
        
        print("requesting ID USER FOR ALERTED TRACKERS")
        print(prefs.object(forKey: "IDUSER"))
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getalertedtrackers_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            print("alertedTrackers json")
            
            
            if(json2["alertedtrackers"].arrayValue.count>1){
            //self.trackerChooserButton.setTitle("Multiple trackers alerted", for: .normal)
           // self.trackerAddressButton.setTitle("Please see alerted trackers", for: .normal)
                print("more that one tracker")
            }
            if(json2["alertedtrackers"].arrayValue.count==1){
            for result in json2["alertedtrackers"].arrayValue {
                let address = result["address"].stringValue
                let name = result["name"].stringValue
                let idTracker = result["id_tracker"].stringValue
                self.trackerChooserButton.setTitle(name, for: .normal)
                self.trackerAddressButton.setTitle(address, for: .normal)
                prefs.set(idTracker, forKey: "IDTRACKER")
            }

            }
        })
        

        
        
        
        
        
    }
    
    //MARK Navigation
    
    
    
    @IBAction func goToTemperature(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "water", sender: self)
        
    }
    
    
    @IBAction func goToMap(_ sender: Any) {
        self.performSegue(withIdentifier: "mainToMap2", sender: self)

    }
    
    
    @IBAction func chooseTracker(_ sender: AnyObject) {
        isTrackerMenuSelected = true
        self.performSegue(withIdentifier: "selectBusiness", sender: self)
        
        
    }
    
    
    
    
    @IBAction func goToPressure(_ sender: AnyObject) {
        let prefs:UserDefaults = UserDefaults.standard
        
        prefs.set(idUser, forKey: "IDUSER")
        prefs.synchronize()
        self.performSegue(withIdentifier: "goToPressure", sender: self)
        
        
        
    }
    
    
    @IBAction func gotopumpstatus(_ sender: UIButton) {
       
         self.performSegue(withIdentifier: "pumpstatus", sender: self)
        
    }
    
    
    
    
    
   
    
    @IBAction func goToMaintenanceMode(_ sender: Any) {
    self.performSegue(withIdentifier: "goToMaintenanceMode", sender: self)
    
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        
        let logoutAlert = UIAlertController(title: "Are you sure", message: "If you logout you will not be able to receive further alerts or notifications on your systems", preferredStyle: UIAlertControllerStyle.alert)
        
        if(!NetworkState.isConnectedToNetwork()){
            
            self.showErrorMessage()
            
        }
        else{
        
        logoutAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            let params  = [ "id_user": UserDefaults.standard.object(forKey: "IDUSER") as AnyObject ]
            
            
           
            
            
            let handler = AlamoFireRequestHandler()
            handler.processRequest(URL: "https://gct-production.mybluemix.net/releasetoken_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
                print("funciono o no el login amigo")
          print(json2["released"])
                if(json2["released"].intValue==1){
                    let defaults = UserDefaults.standard
                    
                    defaults.set(-1, forKey: "IDUSER")
                    defaults.set(0, forKey:"ACCEPTED")
                    defaults.synchronize()
                    
                    
                    self.appDelegate.idUser = defaults.object(forKey: "IDUSER") as! Int
                    self.performSegue(withIdentifier: "logout", sender: self)
                }
            
                else{
                    
                    
                self.showErrorMessage()
                
                
                }
         
            
            })
            
           
            
            
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
            
        }))
        
        
        self.present(logoutAlert, animated: true, completion: nil)
        
        }
    }
    
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {}
    
    
    
    func showErrorMessage(){
        
        let alert = UIAlertController(title: "Notice", message: "Cannot logout, please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       
        
    }
    
    //Mark Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    @IBAction func goToDatalogged(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToSelectFilter", sender: self)

    }
    
    @IBAction func mainToMap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "mainToMap2", sender: self)

    }
    
    @IBAction func addressToSelectTracker(_ sender: Any) {
   
        self.performSegue(withIdentifier: "selectBusiness", sender: self)

    }
    @IBAction func goToPumpDescription(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "pumpdescription", sender: self)
        
    }
    
    @IBAction func goToAlertedTrackers(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "mainToAlertedTrackers", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        print("prepare for segue")
        if(isTrackerMenuSelected){
            
            isTrackerMenuSelected=false
            if(segue.identifier=="selectBusiness"){
                print("entre aqui amigo")
            let destination = segue.destination as! SelectTrackerViewController
            destination.segueFromController = "MainMenuViewController"
            }
            }
    }
    
}
