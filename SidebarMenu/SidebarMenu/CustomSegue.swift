//
//  CustomSegue.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 09/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
public class CustomSegue: UIStoryboardSegue{
    
    
    
    
    override public func perform() {
        let fromVC = source 
        let toVC = destination as! UIViewController
        
        var vcs = fromVC.navigationController?.viewControllers
        vcs?.removeLast()
        vcs?.append(toVC)
        
        fromVC.navigationController?.setViewControllers(vcs!,
                                                        animated: true)
    }
    }
