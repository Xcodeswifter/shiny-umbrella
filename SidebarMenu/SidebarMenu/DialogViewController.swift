//
//  DialogViewController.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/25/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class DialogViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    
    public  func showNoInternetDialog(){
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        var alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })


        
        
        
    }
    
    
    public func showNoTrackersFoundDialog(){
        
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No trackers found for this user", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        

        
    }
    
    
    public func showNoEventReportsFoundDialog(){
        
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No events reports found", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        
        
        
    }
    
    

    
    public func noPumpsFoundFoundDialog(){
        
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        
        
    }
    
    
    
    
    
    public func noLogsFoundDialog(type:String){
        if(type=="incident"){
    
    let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    topWindow.rootViewController = UIViewController()
    topWindow.windowLevel = UIWindowLevelAlert + 1
    let alert: UIAlertController =  UIAlertController(title:"Data Log", message:"No incident history found", preferredStyle:.alert)
    let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
    handler: {
    (paramAction:UIAlertAction!) in
    })
    
        
    
    
    alert.addAction(action)
    
    topWindow.makeKeyAndVisible()
    topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
    
    

    
    
    
    }
        
        
        if(type=="alerts"){
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No alerts history found for this pump", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }

        
        
        if(type=="pressure"){
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No data found for this tracker", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }
        
        
        
        if(type=="activation"){
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No activations history found for this pump", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }
        
        if(type=="pumps"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Notice", message:"No pumps found for this tracker", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            

            
            
        }
        
        
        
        
    }
    
    
    
    public func showLoginLogoutDialog(type:String)->Int{
        
        
        let isLoggedOut = 0
        
        if(type=="logout"){
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Are you sure", message:"If you logout you will not be able to receive further alerts or notifications on your systems", preferredStyle:.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                          handler:  { (action: UIAlertAction!) in
                                            
                                            
                                            let params  = [ "id_user": UserDefaults.standard.object(forKey: "IDUSER") as AnyObject ]
                                            
                                            
                                            
                                            
                                            
                                            let handler = AlamoFireRequestHandler()
                                            handler.processRequest(URL: "https://gct-production.mybluemix.net/releasetoken_02.php", requestMethod: .post, params: params as [String : AnyObject],completion: { json2 -> () in
                                                if(json2["released"].intValue==1){
                                                    let defaults = UserDefaults.standard
                                                    
                                                    defaults.set(-1, forKey: "IDUSER")
                                                    defaults.set(0, forKey:"ACCEPTED")
                                                    defaults.synchronize()
                                                    
                                                    let window: UIWindow! = UIWindow()
                                                    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
                                                    let viewController: LoginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                                                    window?.rootViewController = viewController
                                                    window?.makeKeyAndVisible()
                                                    
                                                }
                                                    
                                                else{
                                                    
                                                    
                                                    self.showLogoutErrorDialog()
                                                    
                                                }
                                                
                                                
                                            })
                                            
                                            
                                            
            })
                

            
            
            )
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
                
                
            }))
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }
        
        
        
        if(type=="error"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"GC-Track could not log in ", message:"Please check your username and password", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            

            
            
        }

        
        return isLoggedOut
        
    }

    
    
    
    
    
    public func showLogoutErrorDialog(){
        
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"Notice", message:"Cannot logout ,please check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        

        
        
        
    }
    

    
    
    
    public func showContactSupportDialog(type:String){
        if(type=="OK"){
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"Contact Support", message:"Thank you for writing us, our support team will get in touch with you as soon as possible.", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        

    }
        
        
        if(type=="Error"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Contacting Support", message:"Your message would not be sent at this moment, please email us at support@gc-track.com or give us a call.", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            

            
        }
    
        
    }
    
    
    
    
    public func showUncompleteFieldsDialog(){
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert: UIAlertController =  UIAlertController(title:"Contact Support", message:"Please fill both 'Subject' and 'Description' fields.", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        
        

    
    
    }
    
    
    public func showReplyMessageDialogs(type:String, email:String){
        
        if(type=="OK"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1

            var alert: UIAlertController =  UIAlertController(title:"Sending Message", message:"You  message to "+email+" was sent correctly", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
        }
        
        
        if(type=="Error"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Sending Message", message:"You message to"+email+" would not  be sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }

        
        
        }
    
    
    
    public func showMaintenanceMenuDialogs(type:String){
        
        if(type=="enabled"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Reply Message", message:"Message sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
        }
        
        
        if(type=="disabled"){
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Reply Message Error", message:"Message cannot be sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }
        
        
        
    }

    
    
   
}
