//
//  GetPlaces.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/9/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

internal struct TrackLocationRequest: APIRequest {
    public typealias Response = NoReply
    
    public var resourceName: String {
        return "locations/v2/user/location"
    }
    
    public init(latitude: Double, longitude: Double, accuracy: Double, altitude: Double?, speed: Double?){
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
        self.altitude = altitude
        self.speed = speed
    }
    
    let latitude: Double
    let longitude: Double
    let accuracy: Double
    let altitude: Double?
    let speed: Double?
    
}
