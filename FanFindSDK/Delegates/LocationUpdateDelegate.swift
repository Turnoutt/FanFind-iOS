//
//  LocationUpdateDelegate.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 9/28/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation
import MapKit

protocol LocationUpdateDelegate{
    func locationUpdated(_ location: CLLocationCoordinate2D)
    
    func authorizationStatusChanged(_ status: CLAuthorizationStatus)    
}
