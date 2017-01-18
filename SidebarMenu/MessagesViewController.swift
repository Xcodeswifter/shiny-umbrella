//
//  MessagesViewController.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var messagesTable: UITableView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    var messagelist = [[String: Any]]()
    var messagesSearchResults:Array<Any>?
    let searchTerm = ["fullname":"Luis"]
    var searchActive = false
    var filtered:[String] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        searchBar.delegate = self
        requestTrackerListService()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
       
        print("filter content")
        if self.messagelist == nil {
            self.messagesSearchResults = nil
            return
        }
        
        
        
        
        // Filter the array using the filter method
        self.messagelist = messagelist.filter({(searchTerm) -> Bool in
            print("contenido explicitio")
            // to start, let's just search by typing
            return (searchTerm["fullname"]! as AnyObject).lowercased.range(of: searchText.lowercased()) != nil
        
        })
    update()
    }
    
    
    
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchText: searchString)
        return true
    }
    
//    
//    ///Search bar delegate methods
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        print("si")
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        print("no")
//
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        print("no")
//
//        searchActive = false;
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        print("no")
//        searchActive = false;
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        print("buscando aqui ")
//        self.messagesTable.reloadData()
//    }
    
    //Esto funciona
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchTextoh \(searchText)")
        filterContentForSearchText(searchText: searchText)
    }
    //Esto funciona
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
    }

    
    
    func requestTrackerListService(){
        let prefs:UserDefaults = UserDefaults.standard
        let iduser:Int = prefs.integer(forKey: "IDUSER") as Int
        let params:[String:AnyObject]=[ "id_user": iduser as AnyObject ]
        let handler = AlamoFireRequestHandler()
        handler.processRequest(URL: "https://gct-production.mybluemix.net/tools/getusrmessages_02.php", requestMethod: .post, params: params,completion: { json2 -> () in
            print("el json sote")
            print(json2)
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
                
                
                let obj = ["subject": subject, "message": message, "date":date, "lastseen":lastSeen, "fullname":fullname, "business":business] as [String : Any]
                    
                    messagelist.append(obj as! [String : Any])
                
                
            }
        
        
            update()
        }

    

    
        
        
    
    func update() {
        DispatchQueue.main.async {
            
            self.messagesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.messagesSearchResults?.count ?? 0
        }
        else{
            
        
        
        
        return messagelist.count
            
        }
        
        return messagelist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prefs:UserDefaults = UserDefaults.standard
        
        let cell: MessagesTableViewCell = self.messagesTable.dequeueReusableCell(withIdentifier: "selda") as! MessagesTableViewCell
        
        let object = messagelist[indexPath.row]
        
        cell.titleLabel.text = object["fullname"] as! String?
        cell.subjectLabel.text = object["bussiness"] as! String?
        cell.theDateLabel.text =  object["date"] as! String?
        cell.bodyLabel.text = object["message"] as! String?
        
        return cell
        
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    

  

}
