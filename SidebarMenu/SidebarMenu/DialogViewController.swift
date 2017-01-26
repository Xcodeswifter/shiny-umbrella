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
        var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        var alert: UIAlertController =  UIAlertController(title:"No internet", message:"Check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })


        
        
        
    }
    
    
    public func showNoTrackersFoundDialog(){
        
        var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        var alert: UIAlertController =  UIAlertController(title:"Notice", message:"No trackers found for this user", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        

        
    }
    
    
    
    
    public func noLogsFoundDialog(type:String){
        if(type=="incident"){
    
    var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    topWindow.rootViewController = UIViewController()
    topWindow.windowLevel = UIWindowLevelAlert + 1
    var alert: UIAlertController =  UIAlertController(title:"Data Log", message:"No incident history found", preferredStyle:.alert)
    let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
    handler: {[weak self]
    (paramAction:UIAlertAction!) in
    })
    
        
    
    
    alert.addAction(action)
    
    topWindow.makeKeyAndVisible()
    topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
    
    

    
    
    
    }
        
        
        if(type=="alerts"){
            
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Notice", message:"No alerts history found for this pump", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }

        
        
        if(type=="pressure"){
            
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Notice", message:"No data found for this tracker", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }
        
        
        
        if(type=="activation"){
            
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Notice", message:"No activations history found for this pump", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
            
            
            
        }
        
        if(type=="pumps"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Notice", message:"No pumps found for this tracker", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            

            
            
        }
        
        
        
        
    }
    
    
    
    public func showLoginLogoutDialog(type:String)->Int{
        
        
        var isLoggedOut = 0
        
        if(type=="logout"){
            
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Are you sure", message:"If you logout you will not be able to receive further alerts or notifications on your systems", preferredStyle:.alert)
            
            
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
                                                    defaults.synchronize()
                                                    
                                                    var window: UIWindow!
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
                
                print("no hagas nada")
                
                
            }))
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }
        
        
        
        if(type=="error"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Login error", message:"Please check your user or password", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            

            
            
        }

        
        return isLoggedOut
        
    }

    
    
    
    
    
    public func showLogoutErrorDialog(){
        
        var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        var alert: UIAlertController =  UIAlertController(title:"Notice", message:"Cannot logout ,please check you internet connection", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        

        
        
        
    }
    

    
    
    
    public func showContactSupportDialog(type:String){
        if(type=="OK"){
        var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        var alert: UIAlertController =  UIAlertController(title:"Contact Support", message:"You Message has sent", preferredStyle:.alert)
        let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
        })
        
        
        
        
        alert.addAction(action)
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        

    }
        
        
        if(type=="Error"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Support", message:"Error cannot send contact email", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            

            
        }
    
        
    }
    
    
    
    public func showReplyMessageDialogs(type:String){
        
        if(type=="OK"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Reply Message", message:"Message sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
        }
        
        
        if(type=="Error"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Reply Message Error", message:"Message cannot be sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }

        
        
        }
    
    
    
    public func showMaintenanceMenuDialogs(type:String){
        
        if(type=="enabled"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Reply Message", message:"Message sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
        }
        
        
        if(type=="disabled"){
            var topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            var alert: UIAlertController =  UIAlertController(title:"Reply Message Error", message:"Message cannot be sent", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
            })
            
            
            
            
            alert.addAction(action)
            
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
            
            
            
        }
        
        
        
    }

    
    
   
}