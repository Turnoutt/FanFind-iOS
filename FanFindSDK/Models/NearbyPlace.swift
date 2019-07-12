//
//  NearbyPlace.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/10/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

public class NearByPlace: Decodable {
    
    public var latitude: Double?
    public var longitude: Double?
    public var name: String?
    public var placeId: String?
    public var peopleCount: Int64?
    
    public init(name: String?, placeId: String?, peopleCount: Int64?, latitude: Double, longitude:Double) {
        
        self.name = name
        self.placeId = placeId
        self.peopleCount = peopleCount
        self.latitude = latitude
        self.longitude = longitude
    }
}
