//
//  ContactViewController.swift
//  GCTRACKV2
// Class used for contacting support from the app
//  Created by Carlos Torres on 9/7/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var subject: UITextField!
    
    @IBOutlet weak var issue: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject.delegate=self
        issue.delegate=self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    // MARK Action
    
    @IBAction func callSuport(_ sender: AnyObject) {
        UIApplication.shared.openURL(NSURL(string: "tel://018004287225")! as URL)
        
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    //optimized
    @IBAction func SendReport(_ sender: AnyObject) {
   
        let prefs:UserDefaults = UserDefaults.standard
        
        let idUser:Int = prefs.integer(forKey: "IDUSER") as Int
        
        requestReportSendingService(idUser: idUser)
        
        
        
    }
    
    
    
    
    func requestReportSendingService(idUser:Int){
        
        
        let params:[String:AnyObject]=[ "id_user": idUser as AnyObject, "subject":subject.text as AnyObject, "message":issue.text as AnyObject ]
        
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/contactsupport_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            print(json2)
            if(json2["mailSent"].intValue==1){
                let alert = UIAlertController(title: "Contact Support", message: "You Message has sent", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                
            else{
                let alert = UIAlertController(title: "Contact Support", message: "Error cannot send contact email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
        
        
    }
    
    
    
    
    @IBAction func CancelRequest(_ sender: AnyObject) {
        subject.text=""
        issue.text=""
    }
    
    
    
    //MARK Delegates 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}
