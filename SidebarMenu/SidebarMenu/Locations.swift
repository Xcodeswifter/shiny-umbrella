//
//  Locations.swift
//  GCTRACKV2
// Class to represent a location(pin) of a tracker in a map
//  Created by Carlos Torres on 9/12/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import Foundation
import MapKit
class Locations: MKPointAnnotation{
    
    var locationTitle: String?
    var locationSubtitle: String?
    var latitude: Double = 0.0
    var longitude:Double = 0.0
    var idTracker:Int = 0
    var Image: String?="iconomapalogo"
    var alerted:Int=0
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
   }
