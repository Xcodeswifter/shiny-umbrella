//
//  TermsAndConditionsViewController.swift
//  GCTRACKV2
//  Shows the terms and conditons view controller, also implements options for accept/decline the terms
//  Created by Carlos Torres on 9/13/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//
import Foundation

class TermsAndConditionsViewController: UIViewController {
    @IBOutlet weak var termsAndConditionsText: UITextView!
   
    @IBOutlet weak var AcceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
   
    
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }

    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        termsAndConditionsText.setContentOffset(CGPoint.zero, animated: false)
    }

    
    
    func updateInterface(){
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(0, forKey: "ACCEPTED")
        prefs.synchronize()
        let iduser = prefs.integer(forKey: "IDUSER")
        if(iduser<=0){
            AcceptButton.isHidden=true
            declineButton.isHidden=true
        }
        else{
            goBackButton.isHidden = true
        }
        
    }
    
    //optimized'
    @IBAction func gotomain(_ sender: AnyObject) {
        updateUserStatus()
        self.performSegue(withIdentifier: "gotomain", sender: self)
       }
    
    
    @IBAction func decline(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        defaults.set(-1, forKey: "IDUSER")
        defaults.synchronize()
        self.performSegue(withIdentifier: "decline", sender: self)
        
    }
    
    
    @IBAction func returnToLoginScreen(_ sender: Any) {
    self.performSegue(withIdentifier: "returnToLogin", sender: self)
    
    }
    
    
    func updateUserStatus(){
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(1,  forKey: "ACCEPTED")
        prefs.synchronize()
    }
    
}
