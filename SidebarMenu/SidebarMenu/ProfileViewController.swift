//
//  ProfileViewController.swift
//  GCTRACKV2
//  Shows the user data for a specific user id
//  Created by Carlos Torres on 9/13/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Company: UITextField!
    
    //optimized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        requestUserProfileData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
            requestUserProfileData()
    }
    
    func requestUserProfileData(){
        let prefs:UserDefaults = UserDefaults.standard
        
        let  idUser = prefs.integer(forKey: "IDUSER") as Int
        
        
        let params:[String:AnyObject]=[ "id_user": idUser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/getcontactdata_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            self.Username.text=json2["userName"].stringValue
            self.FullName.text=json2["fullName"].stringValue
            self.Company.text=json2["company"].stringValue
            self.Phone.text=json2["phoneNumber"].stringValue
            
        })
        
        
    }
    
    
    
}
