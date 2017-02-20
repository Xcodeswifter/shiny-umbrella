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

    @IBOutlet weak var messageTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var subjectLabel: UITextView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var replyText: UITextView!
    @IBOutlet weak var newMessageLabel: UILabel!
    var selectedFullName:String = ""
    var selectedbusiness:String = ""
    var selectedDate:String = ""
    var selectedmessage:String = ""
    var idSender:Int = 0
    var subject = ""
    var idDestination = 0
    var newMsg = ""
    var msgType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderLabel.text = selectedFullName
        dateLabel.text = selectedDate
        subjectLabel.text = selectedbusiness
        messageText.text = selectedmessage
        messageText.textColor = UIColor.white
        messageTypeLabel.text = msgType
        newMessageLabel.text = newMsg
        subjectLabel.text = subject
      messageText.font = UIFont(name:"SF UI Text", size:17.0)
        

        // Do any additional setup after loading the view.
    }


    
    
    @IBAction func goback(_ sender: Any) {
        print("goback mah friend")
   self.performSegue(withIdentifier: "replyToMessage", sender: self)
    
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    
    @IBAction func sendReplyMessage(_ sender: Any) {
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        print("id del destino")
        print(idDestination)
        let dialog = DialogViewController()
        let params:[String:AnyObject]=[ "id_sender": iduser as AnyObject, "to": idDestination as AnyObject, "subject":"test " as AnyObject,"message":replyText.text as AnyObject]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/inbox_send.php", requestMethod: .post, params: params,completion: { json2 -> () in
            print("respuesta")
            print(json2)
            if(json2["sent"]==1){
               
                dialog.showReplyMessageDialogs(type:"OK")
                
            }   else{
                    dialog.showReplyMessageDialogs(type:"Error")
                
           
                
                }
        })
        

        
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
