//
//  MainScreenController.swift
//  GCTRACKV2
//  Class used to manage the transitions between the diferent views of the tabBarController
//. Created by Carlos Torres on 10/19/16.
//  Copyright (c)2016 GC-Track. All rights reserved.
//

import UIKit

class MainScreenController: UITabBarController, UITabBarControllerDelegate,UITextFieldDelegate{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.white
        
        self.delegate=self
        
        let prefs:UserDefaults = UserDefaults.standard
        let idUser:Int = prefs.integer(forKey: "IDUSER") as Int
        
        if (idUser <= 0) {
            
            
            
            
        } else {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    
    
    
    
    
    
    //MARK: -  DELEGATES
    
    
        override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        
    }
    
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
