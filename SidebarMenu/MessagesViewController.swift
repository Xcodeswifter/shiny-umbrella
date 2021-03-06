//
//  MessagesViewController.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON


class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate {

    @IBOutlet weak var messagesTable: UITableView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    var messagelist = [[String: Any]]()
    var filteredMessageList = [[String: Any]]()

    var messagesSearchResults:Array<Any>?
    let searchTerm = ["fullname":"Luis"]
    var searchActive = false
    var filtered:[String] = []
    var selectedFullName:String = ""
    var selectedbusiness:String = ""
    var selectedDate:String = ""
    var selectedmessage:String = ""
    var selectedSubject:String = ""
    var idSender:Int = 0
    var refreshControl = UIRefreshControl()
     var searchController: UISearchController!
    var messagesending = 0

    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        messagesTable.delegate = self
        messagesTable.dataSource = self
        searchBar.delegate = self
        searchController.delegate = self
        let defaults = UserDefaults.standard

        setupKCFloatingActionButton(isMasterUser: defaults.integer(forKey: "MASTER"))
        
        
        
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
       
        self.refreshControl.addTarget(self, action: #selector(MessagesViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

        self.messagesTable?.addSubview(refreshControl)
       requestMessageListService()
        
    }
    
    
    
    
    func setupKCFloatingActionButton(isMasterUser: Int){
        
        
        
        
        if(isMasterUser==1){
        let fab = KCFloatingActionButton()
        fab.buttonColor = UIColor.gray
        fab.itemButtonColor = UIColor.black
        fab.addItem("Send message ", icon: UIImage(named: "newmessage")!, handler: { item in
            self.messagesending = 1
            self.performSegue(withIdentifier: "goToMasterTrackers", sender: self)
            fab.close()
        })
        
        fab.paddingY = 80.1
        self.view.addSubview(fab)
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesTable.delegate = self
        messagesTable.dataSource = self
        searchBar.delegate = self
        searchController.delegate = self
        
        
        

        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        self.refreshControl.addTarget(self, action: #selector(MessagesViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.messagesTable?.addSubview(refreshControl)
        
        
               // messagelist.removeAll()
        //filteredMessageList.removeAll()
        update()
        requestMessageListService()
        
        //requestMessageListService()

        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
   
    
      
    @IBAction func unwindToMessagesMenu(segue: UIStoryboardSegue) {}


    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        
        
        
       searchActive = false
        messagelist.removeAll()
        filteredMessageList.removeAll()
        update()
        requestMessageListService()
        
        
        refreshControl.endRefreshing()
    }
    
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
       
        let searchString = searchText
    
        
        
        

        filteredMessageList = messagelist.filter({(searchTerm) -> Bool in
            let searchText:NSString! = searchTerm["fullname"] as! NSString
            // to start, let's just search by typing
            return (searchText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound

            
            
        })
        
        
        
    update()
    }
    
    
    
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }
    
     func searchDisplayController(_ controller: UISearchController, didLoadSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = 94.4
        tableView.backgroundColor = UIColor.black
        
        
    }
    
    
    ///Search bar delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        update()

        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchActive = false;
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
            filterContentForSearchText(searchText: searchText)
        self.messagesTable.reloadData()
    }
    
    //Esto funciona
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    
    }
    //Esto funciona
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        // messagelist.removeAll()
        update()
    }

    
    
    func requestMessageListService(){
       
        
        
                update()
        
               let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/tools/getusrmessages_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            self.parseJSON(json2)
        })
        
        
    }
    

    
    func parseJSON(_ json: JSON) {
        
        
            for result in json["messages"].arrayValue {
                let subject = result["subject"].stringValue
                let message = result["message"].stringValue
                let date = result["fecha"].stringValue
                let lastSeen = result["visto"].stringValue
                let fullname = result["fullname"].stringValue
                let business = result["business"].stringValue
                let senderID = result["sender"].intValue
                let msgNum = result["msgNum"].intValue
                let preview = result["preview"].stringValue
                let isRead = UIColor.clear
                let isNotRead = UIColor.red
                if(lastSeen=="0"){
                    let obj = ["msgNum":msgNum, "subject": subject, "message": message, "date":date, "lastseen":isNotRead, "fullname":fullname, "business":business,"sender":senderID,"preview":preview] as [String : Any]
                    
                    messagelist.append(obj)

                    
                }
                else{
                    let obj = ["msgNum":msgNum, "subject": subject, "message": message, "date":date, "lastseen":isRead, "fullname":fullname, "business":business,"sender":senderID, "preview":preview] as [String : Any]
                    
                    messagelist.append(obj)
                    
                }
                
                
                
                
                
            }
        
        
            update()
        }

    

    
        
        
    
    func update() {
        DispatchQueue.main.async {
            
            self.messagesTable.reloadData()
        }
    }
    
    func startLoading(){
        loadingSpinner.startAnimating()
        
        
    }
    
    func stopLoading(){
        loadingSpinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredMessageList.count
        }
        else{
            
        
        
        
        return messagelist.count
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = UserDefaults.standard
        let cell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell
        
      
                if(searchActive){
            
           // searchActive=false
            
            let object = filteredMessageList[indexPath.row]
            
            
            cell.isReadImage.backgroundColor = object["lastseen"] as? UIColor
            
            
            
            
            
            cell.titleLabel.text = object["fullname"] as! String?
            cell.subjectLabel.text = object["subject"] as! String?
            cell.theDateLabel.text =  object["date"] as! String?
            
            cell.bodyLabel.text = object["preview"] as! String?
            cell.bodyLabel.textColor = UIColor.white
            
            return cell
       
        }
        else{
        let cell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell
        
        let object = messagelist[indexPath.row]
        
        
        cell.isReadImage.backgroundColor = object["lastseen"] as? UIColor

      
            
        
        
        cell.titleLabel.text = object["fullname"] as! String?
        cell.subjectLabel.text = object["subject"] as! String?
        cell.theDateLabel.text =  object["date"] as! String?
        cell.bodyLabel.text = object["preview"] as! String?
            cell.bodyLabel.textColor = UIColor.white
            
               noMessagesLabel.isHidden = true
            return cell
        
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(searchActive){
        let object = filteredMessageList[indexPath.row]

        let currentCell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell

        
            currentCell.isReadImage.isHidden = true

       
           
        
         selectedFullName = (object["fullname"] as! String?)!
        selectedbusiness = (object["business"] as! String?)!
        selectedDate =  (object["date"] as! String?)!
        selectedmessage = (object["message"] as! String?)!
        idSender = (object["sender"] as! Int?)!
        selectedSubject = (object["subject"] as! String?)!
        
        
      
        

        unMarkMessage(msgNum: object["msgNum"]as! Int)
            
            
       self.performSegue(withIdentifier: "replymessage", sender: self)
            
            
        }
        
        else{
        
            let object = messagelist[indexPath.row]
            
            let currentCell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell
            

            currentCell.isReadImage.isHidden = true

            
            
            selectedFullName = (object["fullname"] as! String?)!
            selectedbusiness = (object["business"] as! String?)!
            selectedDate =  (object["date"] as! String?)!
            selectedmessage = (object["message"] as! String?)!
            idSender = (object["sender"] as! Int?)!
            
            
            
            
            
            unMarkMessage(msgNum: object["msgNum"]as! Int)
            
            
            self.performSegue(withIdentifier: "replymessage", sender: self)
        
        
        
        
        }
        
        
        
    }
    
    
    func unMarkMessage(msgNum:Int){
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/markmessage_02.php", requestMethod: .post, params: ["msgNum": msgNum as AnyObject],completion: { json2 -> () in
            self.parseJSON(json2)
        })

        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(messagesending==0){
            let nextScene =  segue.destination as! ReplyMessageViewController
            
            
               
    nextScene.selectedFullName =  selectedFullName
        nextScene.selectedDate =  selectedDate
        nextScene.subject =  selectedbusiness
        nextScene.selectedmessage =  selectedmessage
        nextScene.idSender = idSender
        nextScene.idDestination = idSender
        nextScene.msgType = "Reply"
        nextScene.newMsg = "Write a reply"
        
    
        
        
    
    }
        messagesending = 0
    }
  

}
