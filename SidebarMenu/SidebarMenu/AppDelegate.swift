
//  AppDelegate.swift
//  SidebarMenu
//
//
//  Copyright (c)2016 GC-Track. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation
import Alamofire
import SwiftyJSON

extension String {
    
    func contains(find: String) -> Bool{ return self.range(of: find) != nil }
    
    func containsIgnoringCase(find: String) -> Bool{ return self.range(of: find, options: .caseInsensitive) != nil }
    
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow!
    var idUser:Int=0
    var pushNotificationArrived: Int = 0
    var PushNotificationMessage:String=""
    var hours:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    var secondsCount:Int = 0
    var timer:Timer = Timer()
    var timerAtInvalidate = NSDate()
    var timerDefaults:UserDefaults = UserDefaults.standard
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        // set the type as sound or badge
        
        
        print("este menazo")
        print("alola mola perros")
        application.applicationIconBadgeNumber = 0; // Clear badge when app launches
        
        
        
        if(pushNotificationArrived==1){
            print("entrando a la pantalla de alarma")
            self.pushNotificationArrived=0
             application.applicationIconBadgeNumber = 0;            
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            
            
            
        }
        
        // Check if launched from notification
        print("por aqui tuvo que haber entrado")
        if (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject]) != nil {
            
//            var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//            var viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
//            
//            window?.rootViewController = viewController
//            window?.makeKeyAndVisible()
            
        } else {
            //Do nothing
        }
        
        return true
        
        
    }
    
    func handlePushNotificationWithUserInfo(launchOptions: [NSObject: AnyObject]?) {
        //Handle PushNotification when app is opened
    }
    
    
    
    
    
    public func requestUserPushNotification(){
        //create the notificationCenter
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
    }
    
    
    
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "token": deviceTokenString as AnyObject,"id_user": iduser as AnyObject, "device":"IOS" as AnyObject ]
        print("the token is here")
        print(deviceTokenString)
        Alamofire.request("https://gct-production.mybluemix.net/registertoken_02.php",method: .post, parameters: params, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            
            
            
            if((response.result.value) == nil){
                //TODO add handler for this condition
                
            }
            else{
                
                _ = JSON(response.result.value!)
                
                
            }
        }
        
        
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
        
        print("did receive remote notification  \(userInfo)")
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if (alert["body"] as? String) != nil {
                    
                }
            }
        }
        
        
        if(PushNotificationMessage.containsIgnoringCase(find: "jockey")){
            print("Jockey")
            
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: JockeyPumpViewController = storyboard.instantiateViewController(withIdentifier: "jockey") as! JockeyPumpViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            
            
        }
        
        
        
        
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
        
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
        
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("did receive remote notification  completionHandler pinche gatito\(userInfo)")
        
        
           _=""
        
        var isJockeyPumpAlert=false
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if (alert["message"] as? NSString) != nil {
                    
                }
            } else if let alert = aps["alert"] as? NSString {
                PushNotificationMessage=alert as String
                
                completionHandler(.newData)
                
            }
        }
        
        
        
        print(PushNotificationMessage)
        if(PushNotificationMessage.containsIgnoringCase(find: "jockey")){
            
            print("is jockey pump alert true")
            
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: JockeyPumpViewController = storyboard.instantiateViewController(withIdentifier: "jockey") as! JockeyPumpViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            isJockeyPumpAlert=true
            print(isJockeyPumpAlert)

        }
        
        
        
        
      else  if(PushNotificationMessage.containsIgnoringCase(find: "ready")){
            
            
//            print("systems ready")
//            var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//            print("aqui se truena")
//             var viewController: SelectTrackerViewController = storyboard.instantiateViewController(withIdentifier: "trackerselect") as! SelectTrackerViewController
//            
//            self.window!.rootViewController = viewController
//            self.window!.makeKeyAndVisible()
//
        
        }
            
        else  if(PushNotificationMessage.containsIgnoringCase(find: "message")){
            
            print("you have a message")
//          this code snippet causes the app to crash
//            var storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//            var viewController: MainScreenController = storyboard.instantiateViewController(withIdentifier: "mainscreen") as! MainScreenController
//            
//            self.window!.rootViewController = viewController
//            self.window!.makeKeyAndVisible()
            
            
        }
   
            
            
        
        
        
        else{
            
            print("is an alert")
            self.pushNotificationArrived=0
            generateLocalNotification()
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()

        }
        
        
    }
    
    
    func application(_ application: UIApplication,
                     didReceive notification: UILocalNotification){
        
        //Method called when the user recieves a LocalNotification
        
        print("local notification recieved amigo")
        
        _ = UserDefaults.standard
        
       
           print("generando notificacion local perro")
            generateTimeUpNotification()
            
        
        
        self.pushNotificationArrived=0
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
        
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
        
    }
    
    
    
    // MARK UNNotificationCenter Delegate Methods
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        /**
         If your app is in the foreground when a notification arrives, the notification center calls this method to deliver the notification directly to your app. If you implement this method, you can take whatever actions are necessary to process the notification and update your app. When you finish, execute the completionHandler block and specify how you want the system to alert the user, if at all.
         
         If your delegate does not implement this method, the system silences alerts as if you had passed the UNNotificationPresentationOptionNone option to the completionHandler block. If you do not provide a delegate at all for the UNUserNotificationCenter object, the system uses the notification’s original options to alert the user.
         
         see https://developer.apple.com/reference/usernotifications/unusernotificationcenterdelegate/1649518-usernotificationcenter
         
         **/
        
        print("APPDELEGATE: willPresentNotification \(notification.request.content.userInfo)")
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        /**
         Use this method to perform the tasks associated with your app’s custom actions. When the user responds to a notification, the system calls this method with the results. You use this method to perform the task associated with that action, if at all. At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification.
         
         You specify your app’s notification types and custom actions using UNNotificationCategory and UNNotificationAction objects. You create these objects at initialization time and register them with the user notification center. Even if you register custom actions, the action in the response parameter might indicate that the user dismissed the notification without performing any of your actions.
         
         If you do not implement this method, your app never responds to custom actions.
         
         see https://developer.apple.com/reference/usernotifications/unusernotificationcenterdelegate/1649501-usernotificationcenter
         
         **/
        
        print("APPDELEGATE: didReceiveResponseWithCompletionHandler \(response.notification.request.content.userInfo)")
        
        
        if(PushNotificationMessage.containsIgnoringCase(find: "jockey")){
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: JockeyPumpViewController = storyboard.instantiateViewController(withIdentifier: "jockey") as! JockeyPumpViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            
        }
        
        
        
        self.pushNotificationArrived=0
        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let viewController: AlarmViewController = (storyboard.instantiateViewController(withIdentifier: "alarm") as? AlarmViewController)!
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
          }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        
        
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  print("entrando al background amigo")
       
        if(timerDefaults.integer(forKey: "ENABLED")==1){
        
        timerAtInvalidate = NSDate()
        timer.invalidate()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background
        print("entrando al foreground amigo ")
        print("start timer peror")
      
        if(timerDefaults.integer(forKey:"ENABLED")==1){
        let elapsedTime = Int(Date().timeIntervalSince(timerAtInvalidate as Date))
        print("ha pasado")
        
        print(Int(elapsedTime))
        secondsCount = secondsCount - elapsedTime
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        updateTimer()
        
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("the aplicacion is activa otra vez")
        if(pushNotificationArrived==1){
            if(PushNotificationMessage.containsIgnoringCase(find: "jockey")){
                let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                let viewController: JockeyPumpViewController = storyboard.instantiateViewController(withIdentifier: "jockey") as! JockeyPumpViewController
                
                self.window!.rootViewController = viewController
                self.window!.makeKeyAndVisible()
                
            }
            
            
            
            
            self.pushNotificationArrived=0
            let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            let viewController: AlarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm") as! AlarmViewController
            
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            
            
            
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func generateLocalNotification(){
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 40) as Date
        notification.alertBody = PushNotificationMessage
        notification.alertAction = "open"
        notification.hasAction = true
        notification.soundName = "alarm.caf";
        notification.userInfo = ["UUID": "reminderID" ]
        notification.repeatInterval = NSCalendar.Unit.minute
        UIApplication.shared.scheduleLocalNotification(notification)
        
    }
    
    
    func generateTimeUpNotification(){
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        notification.alertBody = "Times up"
        notification.alertAction = "open"
        notification.hasAction = true
         notification.soundName = "default"
        notification.userInfo = ["UUID": "reminderID" ]
        UIApplication.shared.scheduleLocalNotification(notification)
        

        
        
    }
    
    func generateTimerIntervalNotification(duration:TimeInterval){
       
        print("the duration is "+duration.description)
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: duration) as Date
        notification.alertBody = "Times up"
        notification.alertAction = "open"
        notification.hasAction = true
         notification.soundName = "default"
        notification.userInfo = ["UUID": "reminderID" ]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
        
        
    }
    

    
    
    
    func scheduleTimer(duration:TimeInterval){
        
        let Defaults = UserDefaults.standard
        
        Defaults.set(1, forKey: "ENABLED")
        print("la duracion es ")
        print(duration)//duration in seconds
        
        
        
        seconds = Int(duration)
        
        
        hours = Int(duration/3600.0)
        print("las horas")
        print(hours)
        
        minutes = (Int(duration) - (3600*hours))/60
        print("los minutos")
        print(minutes)
        seconds = Int(duration) - ((hours*3600)+(minutes*60))
        print("los minutos menazo")
        print(minutes)
        
        secondsCount = ((hours * 3600) + (minutes * 60));
        print("seconds count")
        print(secondsCount)
        
        
       
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }

    
    
    
    
    func updateTimer(){
       print("porque entra aqui cuando no debe de hacerlo pandejo")
        
    secondsCount-=1
        hours = secondsCount/3600 //OK
        minutes = (Int(secondsCount) - (3600*hours))/60 //OK
        seconds = secondsCount-((hours*3600)+(minutes*60))
        print("el timer es ")
        print(hours)
        print(minutes)
        print(seconds)
        
        print("el reloj es ")
        print(String(format:"%02i:%02i:%02i",hours, minutes, seconds))
        if (secondsCount <= 0) {
            
            print("se acabo el tiempo amigo")
            
            timer.invalidate()
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(1, forKey: "TIMEUP")
            userDefaults.set(0, forKey: "ENABLED")
//            var alertController:UIAlertController?
//            alertController = UIAlertController(title: "Maintenance Mode",
//                                                message: "Maintenance Mode time ended",
//                                                preferredStyle: .alert)
//            
//            let action = UIAlertAction(title: "OK",
//                                       style: UIAlertActionStyle.default,
//                                       handler: {[weak self]
//                                        (paramAction:UIAlertAction!) in
//                                        
//            })
//            
//            alertController?.addAction(action)
//           self.window?.rootViewController?.present(alertController!,
//                         animated: true,
//                         completion: nil)
//
//            
//            
//        }
        
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert: UIAlertController =  UIAlertController(title:"Maintenance mode", message:"Maintenance time ended", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: UIAlertActionStyle.default,
                                                       handler: {
                                                        (paramAction:UIAlertAction!) in
                                                        })

           
            
            alert.addAction(action)
                
                topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: { _ in })
        
        
    }
    }
    
    
    
    func stopTimer(){
     timer.invalidate()
        
    }
    
    func parseJSON(_ json: JSON)-> String {
        var counter:Int=0
        
        for result in json["locations"].arrayValue {
            let alerted = result["alerted"].stringValue
            
            if(alerted=="1"){
                counter+=1
            }
            
        }
        
        if(counter>1){
            return "Multiple Trackers with problems"
        }
        
        return PushNotificationMessage
        
        
    }
    
    
    
}
