//
//  AlamoFireRequestHandler.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 10/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AlamoFireRequestHandler: NSObject{
    
    var json:JSON = []
    
    
    
    
    
    /// Process all the incoming REST api request for the other classes using the alamo fire framework
    ///
    /// - Parameters:
    ///   - URL: an url string http://www.example.kom.xx also can be an ip address, works with http and https protocols
    ///   - requestMethod: can be POST or GET
    ///   - params: the parameters sent through POST or GET request
    ///   - completion: handler called when the request has been ended, also this handler is used to obtain the value of the JSON in all of the classes that call this method
    public  func processRequest(URL:URLConvertible, requestMethod:HTTPMethod, params:[String: AnyObject], completion : @escaping (JSON) -> ()){
        
        
    Alamofire.request(URL ,method: requestMethod, parameters: params, headers: nil)   .responseJSON { response in
        
        
print("espere....")
        
            if let status = response.response?.statusCode {
                switch(status){
                
                case 200:
                    print("example success 1")
                    break
                    
                
                case 201:
                    print("example success 2")
                    break
                
                    
                
                case  NSURLErrorTimedOut:
                    
                    print("timed out")
                    completion(self.json)
                    
                    break
                    
                    
                    
                    
                default:
                    print("Response status: \(status)")
                    if(response.result.value == nil){
                        print("terminando abruptamente el request")
                        completion(self.json)
                    }
                    
                
                print(response.result.value ?? "Default value")
                }
            }
            // get JSON return value
            if response.result.value != nil {
                self.json = JSON(response.result.value ?? "default value")
                print("generated json")
                print(self.json)
                completion(self.json)
                
            }
        }
        
        
        
        
        
    }
    
    
    public func stopRequest(){
     
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        
        
        }
        
        
        
    }
    
}
