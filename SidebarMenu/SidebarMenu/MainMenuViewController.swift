//
//  MainMenuViewController.swift
//  GCTRACKV2
// Class to represent the main screen of the app, where the user can go to any other parts of the app, it must not be confused with MainScreenController
//  Created by Carlos Torres on 9/3/16.
//  Copyright ©2016 GC-Track. All rights reserved.
// This is a comment for testing the github commit

import UIKit
import Alamofire
import SwiftyJSON

class MainMenuViewController: UIViewController, UITextFieldDelegate,UIActionSheetDelegate{
    
    @IBOutlet weak var maintenanceButton: UIButton!
    @IBOutlet weak var roomStateIcon: UIButton!
    @IBOutlet weak var trackerAddressButton: UIButton!
    @IBOutlet weak var selectPumpButton: UIButton!
    @IBOutlet weak var selectFiterButton: UIButton!
    @IBOutlet weak var alertedTrackerButton: UIButton!
    @IBOutlet weak var trackerChooserButton: UIButton!
    @IBOutlet weak var systemInfoButton: UIButton!
    @IBOutlet weak var pressureButton: UIButton!
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.idUser=idUser
        
        
        accepted = prefs.integer(forKey: "ACCEPTED")
        print(idUser)
        print(accepted)
        
        
        checkInternetConnection()
        checkifIdUserIsCorrect(idUser: idUser, accepted: accepted)
        NameBusiness = prefs.object(forKey: "NAMEBUSINESS") as! String?
        idUser = prefs.integer(forKey: "IDUSER") as Int
        
        accepted = prefs.integer(forKey: "ACCEPTED")
        
        trackerChooserButton.setTitle(NameBusiness, for: .normal)
        trackerAddressButton.setTitle( prefs.object(forKey: "ADDRESS") as! String?, for: .normal)
        
        let address = prefs.object(forKey: "ADDRESS") as! String?
        let idTracker = prefs.object(forKey: "IDTRACKER")as? Int
        print("los datos amigos")
        print(idTracker ?? "idtracker")
        print(address ?? "address")
        print(NameBusiness ?? "NAMEBUSINESS")
        
        if(address==nil&&NameBusiness==nil && idTracker==nil){
            print("hey amigo")
            prefs.set("Address", forKey: "ADDRESS")
            prefs.synchronize()
            prefs.set("Choose a tracker", forKey: "NAMEBUSINESS")
            prefs.synchronize()
            prefs.set(0, forKey: "IDTRACKER")
            prefs.synchronize()
            selectPumpButton.isEnabled = false
            pressureButton.isEnabled = false
            roomStateIcon.isEnabled = false
            alertedTrackerButton.isEnabled = false
            pressureButton.isEnabled = false
            selectFiterButton.isEnabled = false
            systemInfoButton.isEnabled = false
            
            
            
            
            
            
            
        }
        
        
        
        else{
            
            selectPumpButton.isEnabled = true
            pressureButton.isEnabled = true
            roomStateIcon.isEnabled = true
            alertedTrackerButton.isEnabled = true
            pressureButton.isEnabled = true
            selectFiterButton.isEnabled = true
            systemInfoButton.isEnabled = true
            

        
        checkIfAlerted(idUser: idUser)
        
        
        
        setupAlertedTrackers(prefs: prefs)
        
        
        }
        
        
    }
    
    
    
    
    func checkIfAlerted(idUser:Int){
        
        let params=["id_user":idUser]
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/checkifalerted_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            print("viendo si estan alertados amigo")
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
        
        
        
        
    }
    
    
    
    func setupAlertedTrackers(prefs:UserDefaults){
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
        print(roomState ?? "room state")
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
    
    func checkifIdUserIsCorrect(idUser:Int, accepted:Int){
        
        if (idUser <= 0) {
            print("muerete cabron")
            
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        
        if (accepted<1) {
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        
        
    }
    
    
    
    
    
    
    func checkMaintenanceStatus(prefs:UserDefaults){
        
        if(prefs.integer(forKey: "TIMEUP")==1){
            let buttonImage = UIImage(named: "maintenance")
            maintenanceButton.setImage(buttonImage, for: .normal)
            
        }
        if(prefs.integer(forKey: "ENABLED")==0){
            let buttonImage = UIImage(named: "maintenance")
            
            prefs.set(0, forKey: "TIMEUP")
            
        }
        if(prefs.integer(forKey: "ENABLED")==1){
            let buttonImage = UIImage(named: "maintenancered")
            maintenanceButton.setImage(buttonImage, for: .normal)
            
        }
        
        
        
    }
    
    func checkInternetConnection(){
        
        if(!NetworkState.isConnectedToNetwork()){
            _ = DialogViewController()
            
            showNoInternetDialog()
            
            trackerChooserButton.setTitle("No internet connection", for: .normal)
            print("desconectado")
            
            
            
            
        }
    }
    
    func requestedAlertedTrackers(){
        
        
        let prefs:UserDefaults = UserDefaults.standard
        let params:[String:AnyObject]=[ "id_user": prefs.object(forKey: "IDUSER") as AnyObject ]
        
        print("requesting ID USER FOR ALERTED TRACKERS")
        print(prefs.object(forKey: "IDUSER") ?? "IDUSER")
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getalertedtrackers_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            
            print("alertedTrackers json")
            
            
            if(json2["alertedtrackers"].arrayValue.count>1){
                //self.trackerChooserButton.setTitle("Multiple trackers alerted", for: .normal)
                // self.trackerAddressButton.setTitle("Please see alerted trackers", for: .normal)
                print("more that one tracker")
            }
            if(json2["alertedtrackers"].arrayValue.count==1){
                print("alertedtrackeame esta ")
                for result in json2["alertedtrackers"].arrayValue {
                    let address = result["address"].stringValue
                    let name = result["name"].stringValue
                    let idTracker = result["id_tracker"].stringValue
                    self.trackerChooserButton.setTitle(name, for: .normal)
                    self.trackerAddressButton.setTitle(address, for: .normal)
                    prefs.set(idTracker, forKey: "IDTRACKER")
                    prefs.set(name, forKey: "NAMEBUSINESS")
                    prefs.set(address, forKey: "ADDRESS")
                    
                    print("el id tracker es amigo")
                    print(idTracker)
                    print("la address es")
                    print(address)
                    if(address==""){
                        print("alola land")
                        self.trackerChooserButton.setTitle("Choose a tracker", for: .normal)
                        self.trackerAddressButton.setTitle("Tracker address" as String?, for: .normal)
                        prefs.set("Choose a tracker", forKey: "NAMEBUSINESS")
                        prefs.set("Tracker address", forKey: "ADDRESS")
                        
                        
                    }
                }
                
            }
        })
        
        
        
        
        
        
        
    }
    
    
    func showNoInternetDialog(){
        let alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
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
    
    
    
    
    
    @IBAction func goToMaintenance(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMaintenanceMode", sender: self)
        
    }
    
    
    @IBAction func goToMaintenanceMode(_ sender: Any) {
        
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        
        
        let alert: UIAlertController =  UIAlertController(title:"Clossing Session", message:"Logging out will prevent GC-Track from sending further notifications on this device.", preferredStyle:.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                      handler:  { (action: UIAlertAction!) in
                                        
                                        print("ok yo gano")
                                        
                                        let params  = [ "id_user": UserDefaults.standard.object(forKey: "IDUSER") as AnyObject ]
                                        
                                        
                                        
                                        
                                        
                                        let handler = AlamoFireRequestHandler()
                                        handler.processRequest(URL: "https://gct-production.mybluemix.net/releasetoken_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
                                            print("funciono o no el login amigo")
                                            print(json2["released"])
                                            if(json2["released"].intValue==1){
                                                let defaults = UserDefaults.standard
                                                
                                                defaults.set(-1, forKey: "IDUSER")
                                                defaults.set(0, forKey:"ACCEPTED")
                                                defaults.set(0, forKey:"IDTRACKER")
                                                defaults.set("Choose a Tracker", forKey:"NAMEBUSINESS")
                                                defaults.set("Tracker Address", forKey:"ADDRESS")
                                                
                                                defaults.set(0, forKey:"ACCEPTED")
                                                defaults.set(0, forKey:"MASTER")
                                                
                                                defaults.synchronize()
                                                
                                                
                                                self.performSegue(withIdentifier: "logout", sender: self)
                                                
                                                
                                            }
                                                
                                            else{
                                                
                                                
                                                let errorDialog = DialogViewController()
                                                errorDialog.showLogoutErrorDialog()
                                                
                                                
                                            }
                                            
                                            
                                        })
                                        
                                        
                                        
        })
            
            
            
            
        )
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            print("no hagas nada")
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {}
    
    
    
    
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
