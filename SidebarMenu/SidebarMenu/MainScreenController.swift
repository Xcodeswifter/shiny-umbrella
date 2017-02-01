//
//  MainScreenController.swift
//  GCTRACKV2
//  Class used to manage the transitions between the diferent views of the tabBarController
//. Created by Carlos Torres on 10/19/16.
//  Copyright (c)2016 GC-Track. All rights reserved.
//

import UIKit

class MainScreenController: UITabBarController, UITabBarControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.black
        
        let moreNavbar = self.navigationController?.navigationBar
        let moreNavitem = moreNavbar?.topItem
        
       self.navigationItem.rightBarButtonItem = nil;
        moreNavitem?.rightBarButtonItem = nil;
        let prefs:UserDefaults = UserDefaults.standard
        let idUser:Int = prefs.integer(forKey: "IDUSER") as Int
        
        moreNavitem?.rightBarButtonItem?.title = "EDITARTB"
        moreNavitem?.rightBarButtonItem?.isEnabled = false
        
        
        if (idUser <= 0) {
            
            
            
            
        } else {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        let moreNavbar = self.navigationController?.navigationBar
        let moreNavitem = moreNavbar?.topItem
        self.navigationItem.rightBarButtonItem = nil;
moreNavitem?.rightBarButtonItem?.title = "EDITARTB"
        moreNavitem?.rightBarButtonItem?.isEnabled = false
        
        

    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        let moreNavbar = self.navigationController?.navigationBar
        let moreNavitem = moreNavbar?.topItem
        self.navigationItem.rightBarButtonItem = nil;
        
        moreNavitem?.rightBarButtonItem?.title = "EDITARTB"
        moreNavitem?.rightBarButtonItem?.isEnabled = false
        moreNavitem?.rightBarButtonItem = nil;
        
        moreNavitem?.rightBarButtonItem = nil;

    }
    
    
    
    func navigationController(_ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool){
        
        navigationController.navigationItem.rightBarButtonItem?.isEnabled = false
        
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
