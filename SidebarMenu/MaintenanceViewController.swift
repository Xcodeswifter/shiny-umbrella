//
//  MaintenanceViewController.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 1/2/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MaintenanceViewController: UIViewController {
    
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var timerLabel: UILabel!
    
    var isTimerRunning:Bool = false
    var isPaused:Bool = false
    var hours:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    var secondsCount:Int = 0
    var timer:Timer = Timer()
    var timeAtInvalidate:NSDate = NSDate()
    var elapsedTime:Int = 0
    let defaults = UserDefaults.standard
    @IBOutlet weak var timerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPicker.datePickerMode = .countDownTimer
        timerPicker.setValue(UIColor.white, forKey: "textColor")
        isTimerRunning = false;
        isPaused = false;
        timerLabel.isHidden = true
        
        
        if(defaults.integer(forKey: "ENABLED")==1){
            timerLabel.isHidden=false
            timerPicker.isHidden=true
            timerLabel.text = "Enabled"
            
            timerButton.setTitle("Stop", for:.normal)
            
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        
        if(defaults.integer(forKey: "TIMEUP")==1){
            timer.invalidate()
            timerLabel.text = "00:00"
        }
        if(defaults.integer(forKey: "ENABLED")==1){
            timerLabel.text = "Enabled"
            timerButton.setTitle("Stop", for:.normal)
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @available(iOS 10.0, *)
    @IBAction func startTimer(_ sender: Any) {
        if(timerButton.titleLabel?.text == "Stop"){
            showDisableDialog()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.stopTimer()
            // UIApplication.shared.cancelAllLocalNotifications()
            timerPicker.isHidden = false
            timerLabel.isHidden=true
            timerButton.setTitle("Start", for:.normal)
            print("maintenance mode disabled")
            defaults.set(0, forKey: "ENABLED")
            
        }else{
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            
            print("maintenance mode enabled")
            
            
            
            
            self.showEnableDialog()
            
            
            
            timerPicker.isHidden = true
            timerLabel.isHidden = false
            timerLabel.text = "Enabled"
            timerButton.setTitle("Stop", for: .normal)
            let  duration: TimeInterval = timerPicker.countDownDuration
            appDelegate.scheduleTimer(duration: duration)
            
            
        }
    }
    
    
    
    
    
    func showEnableDialog(){
        let dialog = DialogViewController()
        
        dialog.showMaintenanceMenuDialogs(type:"enabled")
    }
    
    
    
    func showDisableDialog(){
        let dialog = DialogViewController()
        
        dialog.showMaintenanceMenuDialogs(type:"disabled")
        
        
    }
    
    
    
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "maintenancetoMain", sender: self)
    }
}
