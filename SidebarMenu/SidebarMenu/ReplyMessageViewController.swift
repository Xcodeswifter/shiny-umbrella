//
//  ReplyMessageViewController.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/18/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ReplyMessageViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var replyText: UITextView!
    var selectedFullName:String = ""
    var selectedbusiness:String = ""
    var selectedDate:String = ""
    var selectedmessage:String = ""
    var idSender:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderLabel.text = selectedFullName
        dateLabel.text = selectedDate
        subjectLabel.text = selectedbusiness
        messageText.text = selectedmessage
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goback(_ sender: Any) {
   self.performSegue(withIdentifier: "returnToMain", sender: self)
    
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    
    @IBAction func sendReplyMessage(_ sender: Any) {
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        print("id del sender")
        print(idSender)
        let params:[String:AnyObject]=[ "id_sender": idSender as AnyObject, "to": 3 as AnyObject, "subject":"test " as AnyObject,"message":replyText.text as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/inbox_send.php", requestMethod: .post, params: params,completion: { json2 -> () in
            print("respuesta")
            print(json2)
            if(json2["sent"]==1){
               
self.showMessageSentDialog()
                
            }
            else{
                self.showMessageErrorDialog()
                
            }
        })
        

        
    }
    
    
    
    func showMessageSentDialog(){
        let alert = UIAlertController(title: "Reply message", message: "Message sent", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showMessageErrorDialog(){
        let alert = UIAlertController(title: "Reply message error", message: "Message  cannot be sent", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelSend(_ sender: Any) {
        replyText.text = ""
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
