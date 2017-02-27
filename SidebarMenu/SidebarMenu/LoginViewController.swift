//
//  LoginViewController.swift
//  GCTRACKV2
// Handles the login,  user and password validations are done through a external service
//  Created by Carlos Torres on 9/14/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    //optimized
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNetworkState()
        username.delegate = self
        password.delegate=self
        
        hideKeyboardWhenTappedAround()
        
        
        
        
    }
    
    //optimized
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestNetworkState()
    }
    
    
    
    
    
    
    //optimized
    @IBAction func login(_ sender: UIButton) {
       
        requestLoginService()
    }
    
    
    //MARK- Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func readTermsAndCondtions(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "termsandconditions", sender: self)
        
    }
    
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {}
    
    
    func requestNetworkState(){
        if(!NetworkState.isConnectedToNetwork()){
            let dialog = DialogViewController()
            showNoInternetDialog()
            
        }
        
    }
    
    
    
    func showNoInternetDialog(){
        var alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    func requestLoginService(){
        
        
        let activitiyViewController = ActivityViewController(message: "Logging in...")
        present(activitiyViewController, animated: true, completion: nil)
        let params:[String:AnyObject]=[ "email": username.text! as AnyObject, "pass":password.text! as AnyObject ]
        
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/auth_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
            if(json2["id_user"].intValue>0){
                
                let prefs:UserDefaults = UserDefaults.standard
                prefs.set(json2["id_user"].intValue,  forKey: "IDUSER")
                prefs.synchronize()
                prefs.set(json2["master"].intValue,  forKey: "MASTER")
                prefs.synchronize()
                activitiyViewController.dismiss(animated: true, completion:{  self.performSegue(withIdentifier: "termsandconditions", sender: self)})
                
              
                
                
            }
                
            else{
                activitiyViewController.dismiss(animated: true, completion: nil)
                
                
                self.showErrorDialog()
                
            }
        })
    
    }
    
    
    
    func showErrorDialog(){
        
        let loginDialog = DialogViewController()
        
        let result = loginDialog.showLoginLogoutDialog(type: "error")
        
        
        
    }

}
