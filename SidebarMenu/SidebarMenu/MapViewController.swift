//
//  MapViewController.swift
//  GCTrack2
//  Class used to show all the trackers in a MKView(MapKitView)
//  Created by Carlos Torres on 10/19/16.
//  Copyright (c)2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation

class MapViewController: UIViewController,  MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var trackerLabel: UILabel!
    @IBOutlet weak var maplocations: MKMapView!
    var pinAnnotationView:MKPinAnnotationView!
    var locations=[Locations]()
    var SelectedTracker:String? = ""
    var idTrackers=[String]()
    //Holding the name of the controller from where the segue is coming from
    var segueFromController : String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maplocations.delegate = self
        maplocations.mapType = MKMapType.standard
        maplocations.showsUserLocation = true
        let prefs:UserDefaults = UserDefaults.standard
        
        trackerLabel.text = prefs.object(forKey: "NAMEBUSINESS") as! String?
        loadMapData()
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    
    @IBAction func unwindSegue(sender: UIButton) {
        
        print("unwind segue amigote")
                if segueFromController=="DataLogViewController"{
                    print("pressure amigo")
                    self.performSegue(withIdentifier: "backtodatalog", sender: nil)
        
                }
        
                if segueFromController=="SelectTrackerViewController"{
                    print("main menu amigo")
                    self.performSegue(withIdentifier: "backtoselectracker", sender: nil)
                    
                }
                

        
    }
    
    
    

    
    
    @IBAction func goBack(_ sender: Any) {
    
        print("unwind segue amigote")
        if segueFromController=="DataLogViewController"{
            print("pressure amigo")
            self.performSegue(withIdentifier: "backtodatalog", sender: nil)
            
        }
        
        if segueFromController=="SelectTrackerViewController"{
            print("returning to select tracker from map")
            
            
            self.performSegue(withIdentifier: "backtoselectracker", sender: nil)
            
        }
        
        if segueFromController=="LastTenDaysPressureTableViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returntolastendaypressure", sender: nil)
            
        }
        
        if segueFromController=="PressureViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returntosystempressure", sender: nil)
            
        }
        
        if segueFromController=="PumpStatusViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpStatus", sender: nil)
            
        }
        
        
        
        if segueFromController=="PumpRoomConditionsViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returntoPumpRoomConditions", sender: nil)
            
        }
        
        if segueFromController=="PumpInfoViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpInfo", sender: nil)
            
        }
        
        if segueFromController=="LastTenEngineRunViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returntoLastTenEngineRuns", sender: nil)
            
        }

        
        if segueFromController=="SelectPumpRunsViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpRunsMenu", sender: nil)
            
        }
        
        if segueFromController=="SelectPumpIssuesViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToPumpIssues", sender: nil)
            
        }
        
        if segueFromController=="SelectFilterViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectFilterFromMap", sender: nil)
            
        }

        if segueFromController=="SelectedPumpIssueViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSelectedPumpIssue", sender: nil)
            
        }
        
        if segueFromController=="DataLogFormViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToDataLogForm", sender: nil)
            
        }
        
        if segueFromController=="JockeyPumpViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToJockeyPump", sender: nil)
            
        }

        if segueFromController=="SinglePumpStatusViewController"{
            print("main menu amigo")
            self.performSegue(withIdentifier: "returnToSinglePumpStatus", sender: nil)
            
        }

        
        
    
    }
    
//    @IBAction func returnToPreviousSegue(_ sender: Any) {
//        print("unwind segue amigote")
//        if segueFromController=="PressurePumpViewController"{
//            print("pressure amigo")
//            self.performSegue(withIdentifier: "returnToSystemPressure", sender: nil)
//            
//        }
//        
//        if segueFromController=="MainMenuController"{
//            print("main menu amigo")
//            self.performSegue(withIdentifier: "maptomain", sender: nil)
//            
//        }
//        
//    
//    
//    }
    
    
    func loadMapData(){
        let prefs:UserDefaults = UserDefaults.standard
        
        let  idUser = prefs.integer(forKey: "IDUSER") as Int
        
        let params:[String:AnyObject]=[ "id_user": idUser as AnyObject ]
        
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getpumps_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
           print("getpumps amigota")
            print(json2)
            self.parseJSON(json2)
        })

    }
    
    
    
    
    
    func parseJSON(_ json: JSON) {
        
        
        var annotationView:MKPinAnnotationView!
        var annotation :Locations!
        
        for result in json["locations"].arrayValue {
            let lat = result["latitudeLocation"].doubleValue
            let long = result["longitudeLocation"].doubleValue
            let idTracker = result["idTracker"].intValue
            let alerted = result ["alerted"].intValue
            
            if(alerted==1){
            annotation = Locations()
            
            
            annotation.title = result["nameLocation"].stringValue
            annotation.subtitle=result["addressLocation"].stringValue
            annotation.coordinate=CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            annotation.idTracker=idTracker
            annotation.Image = "iconomapalogo"
            annotation.alerted = alerted
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            self.maplocations.addAnnotation(annotationView.annotation!)
            }
            
            else{
                annotation = Locations()
                
                
                annotation.title = result["nameLocation"].stringValue
                annotation.subtitle=result["addressLocation"].stringValue
                annotation.coordinate=CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                annotation.idTracker=idTracker
                annotation.Image = "iconomapalogonegro"
                annotation.alerted = alerted
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                
                self.maplocations.addAnnotation(annotationView.annotation!)
                
                
            }
            
            
        }
        
        
    }
    
    
    //MARK MapKit-Delegates
    
    
    /// Renders all the pins on the map
    ///
    /// - Parameters:
    ///  mapView: the map view to use
    ///   - view: the annotation views(Pins on the map) to display
    ///   - control: the callout used for each pin
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            v?.rightCalloutAccessoryView=btn
        }
        else {
            v!.annotation = annotation
        }
        
        
        let customPointAnnotation = annotation as! Locations
        let pinImage = UIImage(named: customPointAnnotation.Image!)
        
        v!.image = pinImage
        
        return v
        
        
        
        
    }
    
    
    
    
    //
    ///When user taps on the disclosure button you can perform a segue to navigate to another view controller
    
    ///
    /// - Parameters:
    ///   - mapView: the map view to use
    ///   - view: the annotation views(Pins on the map) to display
    ///   - control: the callout used for each pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if control == view.rightCalloutAccessoryView
            
            
        {
            
            
            
            if let pinannotation = view.annotation as? Locations{
                
                let prefs:UserDefaults = UserDefaults.standard
                prefs.set(view.annotation!.title!,  forKey: "NAMEBUSINESS")
                prefs.set(pinannotation.idTracker,  forKey: "IDTRACKER")
                prefs.set(pinannotation.alerted,  forKey: "ALERTEDTRACKER")
                prefs.set(view.annotation!.subtitle!,  forKey: "ADDRESS")
                
                prefs.synchronize()
                self.performSegue(withIdentifier: "maptomain", sender: self)
                
                
                
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SelectTrackerViewController
        destination.segueFromController = "MapViewController"
        
        
        
    }
    
}
