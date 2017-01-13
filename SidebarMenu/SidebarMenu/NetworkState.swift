//
//  NetworkState.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 11/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import SystemConfiguration
public class NetworkState {
    
    
    
    
    
    /// Checks the network state, using the SystemConfiguration Library
    /// - Returns: true if there is network connection otherwhise returns false
    class func isConnectedToNetwork() -> Bool {
        
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
        
        
        
             
        
        
    }
    
    
    
}
